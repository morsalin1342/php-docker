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

`8.5-fpm`, `8.5-cli`, `8.4-fpm`, `8.4-cli`, `8.3-fpm`, `8.3-cli`, `8.2-fpm`, `8.2-cli` (+ `-bookworm` variants), `latest-fpm` → 8.5, `latest-cli` → 8.5

---

### 🔗 Related Images & Tools

| Image / Tool | Description |
|--------------|-------------|
| [morsalin1342/php](https://hub.docker.com/r/morsalin1342/php) | Personal account mirror |
| [easydigital/frankenphp](https://hub.docker.com/r/easydigital/frankenphp) | All-in-one PHP app server (org) |
| [easydigital/caddy](https://hub.docker.com/r/easydigital/caddy) | Standalone Caddy (org) |
| [caddy-souin-cache-manager](https://github.com/morsalin1342/caddy-souin-cache-manager) | WordPress plugin to manage Souin cache from WP Admin |
