# PHP — Enterprise FPM & CLI Images

**Published by [easydigital](https://hub.docker.com/u/easydigital)** · [GitHub](https://github.com/morsalin1342/php-docker)

Enterprise PHP images with 50+ extensions, Composer, WP-CLI, and Supervisor. Same image as `morsalin1342/php` — published here for organizational CI/CD pipelines.

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

## Tags

`8.5-fpm`, `8.5-cli`, `8.4-fpm`, `8.4-cli`, `8.3-fpm`, `8.3-cli`, `8.2-fpm`, `8.2-cli` (+ `-bookworm` and `-trixie` variants), `latest-fpm` → 8.5, `latest-cli` → 8.5

Unsuffixed tags are bookworm; append `-trixie` for Debian 13.

---

### 🔗 Related Images & Tools

| Image / Tool | Description |
|--------------|-------------|
| [easydigital/caddy](https://hub.docker.com/r/easydigital/caddy) | Standalone Caddy with WAF, rate limiting & caching (org) |
| [easydigital/frankenphp](https://hub.docker.com/r/easydigital/frankenphp) | Caddy + PHP app server in one container (org) |
| [easydigital/nginx](https://hub.docker.com/r/easydigital/nginx) | nginx with ModSecurity 3, Brotli, zstd & GeoIP2 (org) |
| [morsalin1342/php](https://hub.docker.com/r/morsalin1342/php) | Personal account mirror |
