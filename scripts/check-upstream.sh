#!/bin/bash
# Compare the version pins in the Dockerfile with the latest upstream releases:
#
#   - each PHP minor's security floor against php.net's latest release of that minor;
#   - NODE_PACKAGE_VERSION against NodeSource's node_<major>.x repository and the
#     nodejs.org release index;
#   - NPM_VERSION against npm's `latest` release;
#   - the Composer image tag against Composer's latest release;
#   - WP_CLI_VERSION against WP-CLI's latest release;
#   - the php-extension-installer image tag against its latest release.
#
# Prints one line per check and exits 1 if anything is behind, 2 if a lookup failed.
# A NOTE line (a PHP minor php.net supports that the build matrix does not include,
# while some listed extension still lacks installer support for it)
# does not change the exit status. Needs bash, curl and jq. GITHUB_TOKEN, when set, is
# sent to the GitHub API to avoid its anonymous rate limit.
set -euo pipefail

cd "$(dirname "$0")/.."

behind=0
failed=0

ok()     { printf 'OK      %s\n' "$*"; }
late()   { printf 'BEHIND  %s\n' "$*"; behind=1; }
note()   { printf 'NOTE    %s\n' "$*"; }
broken() { printf 'ERROR   %s\n' "$*" >&2; failed=1; }

fetch() { curl -fsSL --retry 2 "$@"; }

gh_latest() {
    local auth=()
    if [ -n "${GITHUB_TOKEN:-}" ]; then auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}"); fi
    fetch "${auth[@]}" -H 'Accept: application/vnd.github+json' \
        "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name | ltrimstr("v")'
}

# Succeeds when $1 sorts before $2 as a version.
older() { [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$1" ]; }

# compare <name> <pinned> <latest>
compare() {
    if [ -z "$3" ] || [ "$3" = null ]; then broken "$1: could not read the latest version"
    elif older "$2" "$3"; then late "$1 $2 is pinned; $3 is out"
    else ok "$1 $2 is the latest"
    fi
}

arg() { sed -n "s/^ARG $1=\\(.*\\)\$/\\1/p" Dockerfile | head -n1; }

# PHP security floors, from the case statement in step 0 of the Dockerfile.
floors=$(sed -n 's/^ *\(8\.[0-9]*\)) min=\([0-9.]*\) ;;.*/\1 \2/p' Dockerfile)
[ -n "$floors" ] || { echo "error: no PHP security floors found in the Dockerfile" >&2; exit 2; }
supported=""
while read -r minor floor; do
    if json=$(fetch "https://www.php.net/releases/index.php?json&version=${minor}"); then
        latest=$(jq -r '.version // empty' <<<"$json")
        tags=$(jq -r '(.tags // []) | join(",")' <<<"$json")
        supported=$(jq -r '(.supported_versions // []) | join(" ")' <<<"$json")
        if [ -z "$latest" ]; then broken "PHP ${minor}: php.net returned no version"
        elif older "$floor" "$latest"; then late "PHP ${minor} floor is ${floor}; ${latest} is out (${tags:-no tags})"
        else ok "PHP ${minor} floor ${floor} is the latest release"
        fi
    else
        broken "PHP ${minor}: could not read php.net"
    fi
done <<<"$floors"

# The PHP minors the publish workflow builds, space-separated.
matrix=$(sed -n "s/^ *php_version: *\\[\\(.*\\)\\]/\\1/p" .github/workflows/docker-publish.yml | tr -d "',")
# A supported minor joins the matrix only once the latest extension installer
# release supports every extension in data/installable-extensions for it. Until then
# it is a NOTE naming the missing extensions; once none are missing it is BEHIND.
ipe_latest=$(gh_latest mlocati/docker-php-extension-installer || true)
ipe_supported=""
if [ -n "$ipe_latest" ] && [ "$ipe_latest" != null ]; then
    ipe_supported=$(fetch "https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/${ipe_latest}/data/supported-extensions" || true)
fi
for minor in $supported; do
    case " ${matrix} " in
        *" ${minor} "*) continue ;;
    esac
    if [ -z "$ipe_supported" ]; then
        broken "PHP ${minor}: could not read the extension installer's supported-extensions"
        continue
    fi
    missing=$(awk -v v="$minor" '
        FNR==NR { ok=0; for (i=2; i<=NF; i++) if ($i == v) ok=1; if (ok) has[$1]=1; next }
        NF && !($1 in has) { print $1 }
    ' <(printf '%s\n' "$ipe_supported") data/installable-extensions | xargs)
    total=$(grep -c . data/installable-extensions)
    if [ -n "$missing" ]; then
        note "PHP ${minor} is supported upstream but not built: $(wc -w <<<"$missing") of ${total} listed extensions lack support in php-extension-installer ${ipe_latest} (${missing})"
    else
        late "PHP ${minor}: php-extension-installer ${ipe_latest} supports all ${total} listed extensions; add ${minor} to the build matrix"
    fi
done

# Node.js from NodeSource, and the same version on nodejs.org.
node_major=$(arg NODE_VERSION)
node_pkg=$(arg NODE_PACKAGE_VERSION)
if packages=$(fetch "https://deb.nodesource.com/node_${node_major}.x/dists/nodistro/main/binary-amd64/Packages"); then
    latest_pkg=$(awk '/^Package: nodejs$/{p=1; next} /^Package:/{p=0} p && /^Version:/{print $2}' <<<"$packages" | sort -V | tail -n1)
    compare "NodeSource nodejs package" "$node_pkg" "$latest_pkg"
else
    broken "NodeSource: could not read the node_${node_major}.x repository"
fi
if index=$(fetch https://nodejs.org/dist/index.json); then
    latest_node=$(jq -r --arg m "v${node_major}." '[.[] | select(.version | startswith($m))][0].version // empty | ltrimstr("v")' <<<"$index")
    compare "Node.js ${node_major}" "${node_pkg%%-*}" "$latest_node"
else
    broken "nodejs.org: could not read the release index"
fi

# npm, installed over the one Node.js bundles.
compare "npm" "$(arg NPM_VERSION)" "$(fetch https://registry.npmjs.org/npm/latest | jq -r '.version // empty' || true)"

# Composer, copied from the official image.
composer=$(sed -n 's/^COPY --from=composer:\([0-9.]*\)@.*/\1/p' Dockerfile)
compare "Composer" "$composer" "$(gh_latest composer/composer || true)"

# WP-CLI.
compare "WP-CLI" "$(arg WP_CLI_VERSION)" "$(gh_latest wp-cli/wp-cli || true)"

# The extension installer, copied from its image.
ipe=$(sed -n 's/^COPY --from=ghcr.io\/mlocati\/php-extension-installer:\([0-9.]*\)@.*/\1/p' Dockerfile)
compare "php-extension-installer" "$ipe" "$(gh_latest mlocati/docker-php-extension-installer || true)"

if [ "$failed" -ne 0 ]; then exit 2; fi
exit "$behind"
