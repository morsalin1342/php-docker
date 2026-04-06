# 🚀 Production-Ready PHP Docker Images

[![Docker Pulls](https://img.shields.io/docker/pulls/morsalin1342/php?style=for-the-badge&logo=docker)](https://hub.docker.com/r/morsalin1342/php)
[![GitHub Stars](https://img.shields.io/github/stars/morsalin1342/php-docker?style=for-the-badge&logo=github)](https://github.com/morsalin1342/php-docker)
[![License](https://img.shields.io/github/license/morsalin1342/php-docker?style=for-the-badge)](https://github.com/morsalin1342/php-docker/blob/main/LICENSE)

High-performance, production-ready **PHP-FPM** and **PHP-CLI** Docker images, packed with extensions and tools to supercharge any modern PHP application.

---

## ✨ Why These Images?

*   **Batteries Included**: 50+ optimized PHP extensions, Composer, WP-CLI, and a configurable Node.js version (defaults to 24).
*   **Production Optimized**: Built on official `php:bookworm` bases with `php.ini-production` settings.
*   **Multi-Version**: Maintained builds for PHP 8.2, 8.3, 8.4, and 8.5.
*   **CI/CD Ready**: Lightweight and perfect for automated build pipelines.

---

## 🎯 Ideal For

These images are optimized for a wide range of PHP applications, including:

*   **Laravel**: Ready for queues, broadcasting, and Octane.
*   **Symfony**: All the necessary extensions for a full-featured Symfony project.
*   **WordPress**: Includes WP-CLI and all recommended PHP extensions.
*   **Custom Applications**: A solid foundation for any modern PHP project.

---

## ⚡ Quick Start

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

## 🛠️ Building Locally

If you need to customize the images, you can build them locally. This is useful for changing the Node.js version or adding build-time dependencies.

Clone the repository and use the `--build-arg` flag:
```bash
git clone https://github.com/morsalin1342/php-docker.git
cd php-docker

# Build a PHP 8.4 image with Node.js 22
docker build . \
  --build-arg PHP_VERSION=8.4 \
  --build-arg IMAGE_TYPE=fpm \
  --build-arg NODE_VERSION=22 \
  -t my-custom-php:8.4-fpm
```

---

## 📦 What's Inside?

### PHP Extensions
We include everything you need for modern development:
*   **Performance**: `apcu`, `opcache`, `redis`, `memcached`, `igbinary`.
*   **Databases**: `mysqli`, `pdo_mysql`, `pdo_pgsql`, `mongodb`.
*   **Async**: `swoole`, `amqp`, `pcntl`, `rdkafka`, `sockets`.
*   **Utility & Dev**: `gd`, `intl`, `imagick`, `pcov` (for testing), and many more.

### Essential Tools
*   **Composer** (Latest)
*   **WP-CLI** (WordPress command-line support)
*   **Node.js** (Configurable via build arg, defaults to v24)
*   **System Tools**: `supervisor`, `cron`, `ffmpeg`, `zip/unzip`.

---

## 🏷️ Tagging Strategy

We prioritize stability. Use explicit tags in your production `Dockerfile`:

| Variant | Use Case |
| :--- | :--- |
| `morsalin1342/php:<version>-fpm` | Production Web Servers (includes Supervisor/Cron) |
| `morsalin1342/php:<version>-cli` | Tasks, Migrations, CI/CD Pipelines |

---

## ❓ FAQ

**Q: Can I run custom php.ini configurations?**
A: Absolutely. You can mount your own `php.ini` file into the container:
```yaml
    volumes:
      - ./php.ini:/usr/local/etc/php/php.ini:ro
```

**Q: How do I add extensions not in your list?**
A: Since we use the `mlocati/php-extension-installer` utility, you can easily install any other extension via a custom `Dockerfile` layer:
```dockerfile
FROM morsalin1342/php:8.4-fpm
RUN install-php-extensions my-custom-extension
```

**Q: Why Node.js v24?**
A: We prioritize stability and long-term support. Node.js 24 is excellent for modern build tooling like Vite, Webpack, or TailwindCSS.

**Q: How do I manage queues or background processes?**
A: The `-fpm` images include `supervisor`. You can mount your configuration in `/etc/supervisor/conf.d/` to manage worker processes.

---

## 🤝 Contributing & Issues

Found a bug or need a specific extension?
*   [Open an Issue](https://github.com/morsalin1342/php-docker/issues)
*   [Submit a Pull Request](https://github.com/morsalin1342/php-docker/pulls)

*Built with ❤️ by the community.*
