# PHP-FPM and PHP-CLI Docker Images with Extensions, Composer, WP-CLI and Node.js

[![Docker Pulls](https://img.shields.io/docker/pulls/morsalin1342/php?style=for-the-badge&logo=docker)](https://hub.docker.com/r/morsalin1342/php)
[![GitHub Stars](https://img.shields.io/github/stars/morsalin1342/php-docker?style=for-the-badge&logo=github)](https://github.com/morsalin1342/php-docker)
[![License](https://img.shields.io/github/license/morsalin1342/php-docker?style=for-the-badge)](https://github.com/morsalin1342/php-docker/blob/master/LICENSE)
[![Docker Publish](https://github.com/morsalin1342/php-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/morsalin1342/php-docker/actions/workflows/docker-publish.yml)

PHP-FPM and PHP-CLI images for PHP 8.2, 8.3, 8.4 and 8.5, built on the official `php` images
(Debian 13, trixie). Each adds PHP extensions to the ones the official image loads (52 more on
PHP 8.5), plus Composer, WP-CLI, the MariaDB client and Node.js. There is no web server inside: pair the FPM image with
nginx, Apache or Caddy over FastCGI.

```bash
docker pull morsalin1342/php:8.4-fpm
```

**Platform:** linux/amd64 only. `morsalin1342/php` and `easydigital/php` are the same image, pushed by the same build with the same digest; pull whichever you prefer.

## What it adds to the official image

| | Official `php` | This image |
|---|---|---|
| PHP extensions loaded | 35 on PHP 8.5 | 87 on PHP 8.5: the same 35 plus 52 installed — see [EXTENSIONS.md](EXTENSIONS.md) |
| `php.ini` | none; `php.ini-production` is a template | `php.ini-production` copied into place |
| Composer | ❌ | 2.10.3 |
| WP-CLI | ❌ | 2.12.0, checked against its published SHA-256 |
| Node.js and npm | ❌ | Node.js 24 from NodeSource's signed repository, npm 12.2.3 |
| MariaDB client | ❌ | from MariaDB's signed repository; also answers to `mysql` and `mysqldump` |
| Oldest PHP accepted | — | the build fails on a PHP older than the November 2026 security releases |

PHP 8.2 to 8.5 are built from the same Dockerfile and the same extension list, in an `fpm` and a
`cli` variant each; an extension the installer does not support on a PHP version is skipped for
that version, so the count can be lower there. Nothing in the image is specific to one framework; `pcntl`, `sockets` and
`openswoole` are included for long-running workers, and WP-CLI for WordPress sites.

---

## Quick Start

The recommended way to use these images is to reference them directly from Docker Hub in your `docker-compose.yml` or `Dockerfile`.

### For Web Applications (FPM)
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
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
```

### For CLI Tasks
```bash
# Run Composer install
docker run --rm -v $(pwd):/app morsalin1342/php:8.4-cli composer install

# Run a specific PHP script
docker run --rm -v $(pwd):/app morsalin1342/php:8.4-cli php your-script.php
```

---

## Building Locally

If you need to customize the images, you can build them locally. This is useful for changing the Node.js version or adding build-time dependencies.

Clone the repository and use the `--build-arg` flag (every build argument is listed in [EXTENSIONS.md](EXTENSIONS.md#build-arguments)):
```bash
git clone https://github.com/morsalin1342/php-docker.git
cd php-docker

# Build a PHP 8.4 image with Node.js 22
docker build . \
  --build-arg PHP_VERSION=8.4 \
  --build-arg IMAGE_TYPE=fpm \
  --build-arg NODE_VERSION=22 \
  --build-arg NODE_PACKAGE_VERSION=<a 22.x package from deb.nodesource.com> \
  -t my-custom-php:8.4-fpm
```

---

## What's Inside?

### PHP Extensions
**Every extension and tool, with its version and what it does, is listed in [EXTENSIONS.md](EXTENSIONS.md).** Some of them, by purpose:
*   **Performance**: `apcu`, `opcache`, `redis`, `memcached`, `igbinary`.
*   **Databases**: `mysqli`, `pdo_mysql`, `pdo_pgsql`, `pgsql`, `mongodb`.
*   **Async**: `openswoole`, `pcntl`, `sockets`.
*   **Utility & Dev**: `gd`, `intl`, `imagick`, `ftp`, `opentelemetry`, and many more.

### Essential Tools
*   **Composer** 2.10.3
*   **WP-CLI** 2.12.0 (WordPress command-line support)
*   **Node.js** (Configurable via build arg, defaults to v24)
*   **System Tools**: the MariaDB client (`mariadb`, `mariadb-dump`, also linked as `mysql` and `mysqldump`), `acl`, `ffmpeg`, `zip/unzip`.
*   **Not included**: `supervisor` and `cron`; run workers and schedulers as separate containers.

---

## Tagging Strategy

Use an explicit version tag in a production `Dockerfile`:

| Variant | Use Case |
| :--- | :--- |
| `morsalin1342/php:<version>-fpm` | Production Web Servers |
| `morsalin1342/php:<version>-cli` | Tasks, Migrations, CI/CD Pipelines |

### Base OS

Every version and variant is built on Debian 13 (trixie):

| Tag shape | Base OS |
| :--- | :--- |
| `8.4-fpm`, `8.4-fpm-trixie` | Debian 13 (trixie) |

Only trixie is built; `-trixie` tags are kept as aliases of the unsuffixed ones. bookworm is built again only for a PHP version whose official image has no trixie variant. The old `-bookworm` tags stay on Docker Hub but are no longer updated.

---

## ❓ FAQ

**Q: Can I run custom php.ini configurations?**
A: Yes. Mount your own `php.ini` file into the container (start from [`php.ini.example`](php.ini.example)):
```yaml
    volumes:
      - ./php.ini:/usr/local/etc/php/php.ini:ro
```

**Q: How do I add extensions not in your list?**
A: The image includes `install-php-extensions` (from `mlocati/docker-php-extension-installer`), so another extension is one layer in your own `Dockerfile`:
```dockerfile
FROM morsalin1342/php:8.4-fpm
RUN install-php-extensions my-custom-extension
```

**Q: Why Node.js v24?**
A: Node.js 24 is a long-term-support line, maintained until 2028-04-30 according to the [Node.js release schedule](https://github.com/nodejs/Release). Another major version is a build argument away; see [Building Locally](#building-locally).

**Q: How do I manage queues or background processes?**
A: Run them as separate containers from the same image with their own command (for example `php artisan queue:work`); the images no longer include `supervisor` or `cron`.

---

## Licence

The files in this repository are MIT ([LICENSE](LICENSE)). That licence covers the build files,
not the software in the image, which keeps its own licences. The main components:

| Component | Licence |
|---|---|
| PHP 8.2 to 8.5 | PHP-3.01 (the PHP License) |
| PHP extensions installed on top | each its own; PECL extensions vary |
| Composer | MIT |
| WP-CLI | MIT |
| Node.js | MIT (its bundled dependencies keep theirs) |
| npm | Artistic-2.0 |
| MariaDB client programs | GPL-2.0 |
| FFmpeg, as Debian builds it | GPL-2.0-or-later (Debian builds it with `--enable-gpl`) |
| Debian packages from the base image and `apt-get` | their own licences |

Each build also writes an SPDX SBOM, kept as an artifact of its workflow run, which lists each
package with the licence it declares.

---

## Related Images & Tools

<!-- BEGIN GENERATED: related (from manifest/images.yaml in the morsalin1342/.github repository; do not edit by hand) -->
Every image is published under `morsalin1342` (personal) and `easydigital` (organization), from the same build.

| Repository | Images | Description |
|---|---|---|
| [caddy-docker](https://github.com/morsalin1342/caddy-docker) | `morsalin1342/caddy` · `easydigital/caddy` | Standalone Caddy with WAF, rate limiting & caching |
| [frankenphp-docker](https://github.com/morsalin1342/frankenphp-docker) | `morsalin1342/frankenphp` · `easydigital/frankenphp` | Caddy + PHP app server in one container |
| [nginx-docker](https://github.com/morsalin1342/nginx-docker) | `morsalin1342/nginx` · `easydigital/nginx` | nginx with ModSecurity 3, Brotli, zstd & GeoIP2 |
| [apache-docker](https://github.com/morsalin1342/apache-docker) | `morsalin1342/apache` · `easydigital/apache` | Apache as a static server or php-fpm application server, no PHP inside |
| [adminer-docker](https://github.com/morsalin1342/adminer-docker) | `morsalin1342/adminer` · `easydigital/adminer` | Adminer database tool: the official image plus Alpine security updates |
<!-- END GENERATED: related -->

---

## Feedback and Issues

If you have suggestions, find a bug, or want to request a new extension, please [open an issue](https://github.com/morsalin1342/php-docker/issues) on the GitHub repository.

---

⭐ **If this project helps you, consider giving it a star!**
