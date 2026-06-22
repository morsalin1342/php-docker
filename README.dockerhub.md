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

| Tag | Variant | PHP |
|-----|---------|-----|
| `latest-fpm`, `8.5-fpm`, `8.5-fpm-bookworm` | FPM | 8.5 |
| `latest-cli`, `8.5-cli`, `8.5-cli-bookworm` | CLI | 8.5 |
| `8.4-fpm`, `8.4-fpm-bookworm` | FPM | 8.4 |
| `8.4-cli`, `8.4-cli-bookworm` | CLI | 8.4 |
| `8.3-fpm`, `8.3-cli` | Both | 8.3 |
| `8.2-fpm`, `8.2-cli` | Both | 8.2 |

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
| [morsalin1342/frankenphp](https://hub.docker.com/r/morsalin1342/frankenphp) | All-in-one PHP app server (Caddy + PHP) |
| [morsalin1342/caddy](https://hub.docker.com/r/morsalin1342/caddy) | Standalone Caddy with plugins |
| [easydigital/php](https://hub.docker.com/r/easydigital/php) | Enterprise org mirror |
| [caddy-souin-cache-manager](https://github.com/morsalin1342/caddy-souin-cache-manager) | WordPress plugin to manage Souin cache from WP Admin |
