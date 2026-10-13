# PHP — Production-Ready FPM & CLI Images with Essential Extensions

**Maintained by [morsalin1342](https://hub.docker.com/u/morsalin1342)** · [GitHub](https://github.com/morsalin1342/php-docker)

[![Docker Pulls](https://img.shields.io/docker/pulls/morsalin1342/php?style=for-the-badge&logo=docker)](https://hub.docker.com/r/morsalin1342/php)
[![Image Size](https://img.shields.io/docker/image-size/morsalin1342/php/latest?style=for-the-badge&logo=docker)](https://hub.docker.com/r/morsalin1342/php/tags)
[![GitHub Stars](https://img.shields.io/github/stars/morsalin1342/php-docker?style=for-the-badge&logo=github)](https://github.com/morsalin1342/php-docker)
[![License](https://img.shields.io/github/license/morsalin1342/php-docker?style=for-the-badge)](https://github.com/morsalin1342/php-docker/blob/master/LICENSE)

Batteries-included PHP images with 52 extensions, Composer, WP-CLI, the MariaDB client, and configurable Node.js. Available in FPM (web) and CLI (tasks/CI) variants.

## ✨ Why This Image?

| Feature | Official image | This image |
|---|---|---|
| **PHP extensions** | Few built in | ✅ 52 pre-installed |
| **Composer / WP-CLI** | ❌ | ✅ Both |
| **Node.js** | ❌ | ✅ v24, configurable |
| **MariaDB client** | ❌ | ✅ `mariadb` tools, also as `mysql`, `mysqldump` |
| **Debian release** | One | ✅ trixie (Debian 13) |
| **Variants** | Separate images | ✅ FPM and CLI from one build |

## Quick Start

### Web Applications (FPM + Nginx)

```yaml
# docker-compose.yml
services:
  php:
    image: morsalin1342/php:8.4-fpm
    volumes:
      - ./src:/var/www/html

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./src:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

### CLI Tasks

```bash
docker run --rm -v $(pwd):/app morsalin1342/php:8.4-cli composer install
docker run --rm -v $(pwd):/app morsalin1342/php:8.4-cli php artisan migrate
```

## Available Tags

| Tag | Variant | PHP | Base OS |
|-----|---------|-----|---------|
| `latest-fpm`, `8.5-fpm`, `8.5-fpm-trixie` | FPM | 8.5 | trixie |
| `latest-cli`, `8.5-cli`, `8.5-cli-trixie` | CLI | 8.5 | trixie |
| `8.4-fpm`, `8.4-fpm-trixie` | FPM | 8.4 | trixie |
| `8.4-cli`, `8.4-cli-trixie` | CLI | 8.4 | trixie |
| `8.3-fpm`, `8.3-cli` (+ `-trixie`) | Both | 8.3 | trixie |
| `8.2-fpm`, `8.2-cli` (+ `-trixie`) | Both | 8.2 | trixie |

Only Debian 13 (trixie) is built, and `-trixie` tags are aliases of the unsuffixed ones. The old `-bookworm` tags stay available but are no longer updated.

## What's Included

**The full list of extensions and tools, with versions, is in [EXTENSIONS.md](https://github.com/morsalin1342/php-docker/blob/master/EXTENSIONS.md).**

- **52 PHP extensions** — Redis, MongoDB, PostgreSQL (`pgsql` + `pdo_pgsql`), Imagick, GD, Intl,
  OpenTelemetry, openswoole, `ftp` and more
- **Tools** — Composer, WP-CLI, Node.js 24, the MariaDB client, FFmpeg
- **Two variants** — `-fpm` for web behind nginx or Caddy, `-cli` for tasks, migrations and CI
- **Debian 13 (trixie)** — the current stable release

## Customizing

```bash
docker build . \
  --build-arg PHP_VERSION=8.4 \
  --build-arg IMAGE_TYPE=fpm \
  --build-arg NODE_VERSION=22 \
  --build-arg NODE_PACKAGE_VERSION=<a 22.x package from deb.nodesource.com> \
  -t my-php:8.4-fpm
```

## ❓ FAQ

**Q: FPM or CLI?**
A: FPM for web behind nginx or Caddy; CLI for migrations, queues and CI.

**Q: Can I add extensions?**
A: Yes — `RUN install-php-extensions <name>` in a layer on top.

**Q: Is there a bookworm image?**
A: No. Only trixie is built now. Older `-bookworm` tags stay on Docker Hub but are no longer updated.

---

### 🔗 Related Images & Tools

<!-- BEGIN GENERATED: related (from images.yaml in the org .github repository; do not edit by hand) -->
| Image / Tool | Description |
|--------------|-------------|
| [morsalin1342/caddy](https://hub.docker.com/r/morsalin1342/caddy) | Standalone Caddy with WAF, rate limiting & caching |
| [morsalin1342/frankenphp](https://hub.docker.com/r/morsalin1342/frankenphp) | Caddy + PHP app server in one container |
| [morsalin1342/nginx](https://hub.docker.com/r/morsalin1342/nginx) | nginx with ModSecurity 3, Brotli, zstd & GeoIP2 |
| [morsalin1342/apache](https://hub.docker.com/r/morsalin1342/apache) | Apache as a static server or php-fpm application server, no PHP inside |
| [easydigital/php](https://hub.docker.com/r/easydigital/php) | Same image, organization namespace |
<!-- END GENERATED: related -->

---

⭐ **If this image helps you, consider giving it a star on [GitHub](https://github.com/morsalin1342/php-docker)!**
