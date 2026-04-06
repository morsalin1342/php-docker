# Use a build-time argument to specify the PHP version. Defaulting to 8.4
ARG PHP_VERSION=8.4
# Use a build-time argument to specify the PHP variant (e.g., fpm, cli). Defaulting to fpm.
ARG IMAGE_TYPE=fpm
# Use a build-time argument to specify the Node.js version. Defaulting to 24.
ARG NODE_VERSION=24

# Use the ARG to pull the correct base image
FROM php:${PHP_VERSION}-${IMAGE_TYPE}-bookworm

# Re-declare ARGs to be available in subsequent build stages
ARG PHP_VERSION
ARG IMAGE_TYPE
ARG NODE_VERSION

# ==> 1. Install System Dependencies & Node.js <==
# Install essential system packages and Node.js in a single layer for efficiency.
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gosu \
        libfcgi-bin \
        netcat-openbsd \
        procps \
        unzip \
        zip \
        cron \
        supervisor \
        ffmpeg; \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -; \
    apt-get install -y --no-install-recommends nodejs; \
    rm -rf /var/lib/apt/lists/*

# ==> 2. Install PHP Extensions <==
# First, copy the main installer utility from the official image
COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Copy our custom script and data files
COPY ./scripts/install-extensions.sh /usr/local/bin/
COPY ./data/installable-extensions /tmp/installable-extensions
COPY ./data/supported-extensions /tmp/supported-extensions

# Make our script executable, run it with the correct PHP_VERSION,
# and then clean up the temporary files.
RUN chmod +x /usr/local/bin/install-extensions.sh && \
    install-extensions.sh ${PHP_VERSION} && \
    rm /tmp/installable-extensions /tmp/supported-extensions

# ==> 3. Install Global PHP Tools <==
# Copy Composer from the official image
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Add WP-CLI (WordPress Command Line Interface)
ADD --chmod=0755 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp

# ==> 4. Configure PHP <==
# Use the production php.ini configuration file
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
