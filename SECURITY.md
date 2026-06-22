# Security Policy

## Supported Versions

| Version | Variant | Supported          |
|---------|---------|--------------------|
| 8.5     | fpm/cli | :white_check_mark: |
| 8.4     | fpm/cli | :white_check_mark: |
| 8.3     | fpm/cli | :white_check_mark: |
| 8.2     | fpm/cli | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this image, please report it by opening an issue on GitHub:

- [Report a vulnerability](https://github.com/morsalin1342/php-docker/issues/new)

Please include:
- A clear description of the vulnerability
- Steps to reproduce
- The image tag/version affected

We aim to respond within 48 hours and publish a fix as soon as possible.

## Supported Base Images

These images are built on top of:
- [docker-library/php](https://github.com/docker-library/php) — Official PHP Docker images
- [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) — PHP extension installer

If a vulnerability exists in an upstream component, we will update to the patched version and release updated images.
