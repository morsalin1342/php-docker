# PHP — Production-Ready FPM & CLI Images

**Maintained by [morsalin1342](https://hub.docker.com/u/morsalin1342)** · [GitHub](https://github.com/morsalin1342/php-docker)

Batteries-included PHP images with 50+ extensions, Composer, WP-CLI, and configurable Node.js. Available in FPM (web) and CLI (tasks/CI) variants.

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
| `latest-fpm`, `8.5-fpm`, `8.5-fpm-bookworm` | FPM | 8.5 | bookworm |
| `latest-cli`, `8.5-cli`, `8.5-cli-bookworm` | CLI | 8.5 | bookworm |
| `8.4-fpm`, `8.4-fpm-bookworm` | FPM | 8.4 | bookworm |
| `8.4-cli`, `8.4-cli-bookworm` | CLI | 8.4 | bookworm |
| `8.3-fpm`, `8.3-cli` | Both | 8.3 | bookworm |
| `8.2-fpm`, `8.2-cli` | Both | 8.2 | bookworm |
| `8.5-fpm-trixie` … `8.2-cli-trixie` | Both | 8.2–8.5 | trixie |

`bookworm` owns the unsuffixed tags; append `-trixie` for Debian 13.

## Customizing Node.js Version

```bash
docker build . \
  --build-arg PHP_VERSION=8.4 \
  --build-arg IMAGE_TYPE=fpm \
  --build-arg NODE_VERSION=22 \
  -t my-php:8.4-fpm
```

---

### 🔗 Related Images & Tools

| Image / Tool | Description |
|--------------|-------------|
| [morsalin1342/caddy](https://hub.docker.com/r/morsalin1342/caddy) | Standalone Caddy with WAF, rate limiting & caching |
| [morsalin1342/frankenphp](https://hub.docker.com/r/morsalin1342/frankenphp) | Caddy + PHP app server in one container |
| [morsalin1342/nginx](https://hub.docker.com/r/morsalin1342/nginx) | nginx with ModSecurity 3, Brotli, zstd & GeoIP2 |
| [easydigital/php](https://hub.docker.com/r/easydigital/php) | Enterprise org mirror |
