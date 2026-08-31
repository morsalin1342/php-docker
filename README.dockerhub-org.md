# PHP — Enterprise FPM & CLI Images

**Published by [easydigital](https://hub.docker.com/u/easydigital)** · [GitHub](https://github.com/morsalin1342/php-docker)

[![Docker Pulls](https://img.shields.io/docker/pulls/easydigital/php?style=for-the-badge&logo=docker)](https://hub.docker.com/r/easydigital/php)
[![Image Size](https://img.shields.io/docker/image-size/easydigital/php/latest?style=for-the-badge&logo=docker)](https://hub.docker.com/r/easydigital/php/tags)
[![GitHub Stars](https://img.shields.io/github/stars/morsalin1342/php-docker?style=for-the-badge&logo=github)](https://github.com/morsalin1342/php-docker)
[![License](https://img.shields.io/github/license/morsalin1342/php-docker?style=for-the-badge)](https://github.com/morsalin1342/php-docker/blob/master/LICENSE)

Enterprise PHP images with 57 extensions, Composer, WP-CLI, and Supervisor. Same image as `morsalin1342/php` — published here for organizational CI/CD pipelines.

## ✨ Why This Image?

| Feature | Official image | This image |
|---|---|---|
| **PHP extensions** | Few built in | ✅ 57 pre-installed |
| **Composer / WP-CLI** | ❌ | ✅ Both |
| **Node.js** | ❌ | ✅ v24, configurable |
| **Supervisor + Cron** | ❌ | ✅ In the FPM images |
| **Debian releases** | One | ✅ bookworm and trixie |
| **Variants** | Separate images | ✅ FPM and CLI from one build |

## Available Variants

| Variant | Use Case |
|---------|----------|
| `*-fpm` | Web applications (pair with Nginx/Caddy) |
| `*-cli` | CLI tasks, migrations, CI/CD pipelines |

## Production Deployment

```yaml
# production.yml
services:
  php:
    image: easydigital/php:8.4-fpm-bookworm
    restart: always
    volumes:
      - ./src:/var/www/html
      - ./php.ini:/usr/local/etc/php/php.ini:ro
      - ./www.conf:/usr/local/etc/php-fpm.d/www.conf:ro

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./src:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

## CI/CD Example (GitHub Actions)

```yaml
- name: Run tests
  run: |
    docker run --rm -v ${{ github.workspace }}:/app easydigital/php:8.4-cli \
      sh -c "composer install && php vendor/bin/phpunit"
```

## Available Tags

`8.5-fpm`, `8.5-cli`, `8.4-fpm`, `8.4-cli`, `8.3-fpm`, `8.3-cli`, `8.2-fpm`, `8.2-cli` (+ `-bookworm` and `-trixie` variants), `latest-fpm` → 8.5, `latest-cli` → 8.5

Unsuffixed tags are bookworm; append `-trixie` for Debian 13.

## What's Included

- **57 PHP extensions** — Redis, MongoDB, PostgreSQL (`pgsql` + `pdo_pgsql`), Imagick, GD, Intl,
  AMQP, Kafka, OpenTelemetry, openswoole, `ftp` and more
- **Tools** — Composer, WP-CLI, Node.js 24, Supervisor, Cron, FFmpeg
- **Two variants** — `-fpm` for web behind nginx or Caddy, `-cli` for tasks, migrations and CI
- **Two Debian releases** — bookworm and trixie, from the same build

## ❓ FAQ

**Q: FPM or CLI?**
A: FPM for web behind nginx or Caddy; CLI for migrations, queues and CI.

**Q: Can I add extensions?**
A: Yes — `RUN install-php-extensions <name>` in a layer on top.

**Q: bookworm or trixie?**
A: Unsuffixed tags are bookworm. Append `-trixie` for Debian 13.

---

### 🔗 Related Images & Tools

| Image / Tool | Description |
|--------------|-------------|
| [easydigital/caddy](https://hub.docker.com/r/easydigital/caddy) | Standalone Caddy with WAF, rate limiting & caching (org) |
| [easydigital/frankenphp](https://hub.docker.com/r/easydigital/frankenphp) | Caddy + PHP app server in one container (org) |
| [easydigital/nginx](https://hub.docker.com/r/easydigital/nginx) | nginx with ModSecurity 3, Brotli, zstd & GeoIP2 (org) |
| [morsalin1342/php](https://hub.docker.com/r/morsalin1342/php) | Personal account mirror |

---

⭐ **If this image helps you, consider giving it a star on [GitHub](https://github.com/morsalin1342/php-docker)!**
