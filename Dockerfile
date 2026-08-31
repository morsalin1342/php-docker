# Use a build-time argument to specify the PHP version. Defaulting to 8.4
ARG PHP_VERSION=8.4
# Use a build-time argument to specify the PHP variant (e.g., fpm, cli). Defaulting to fpm.
ARG IMAGE_TYPE=fpm
# Use a build-time argument to specify the Node.js version. Defaulting to 24.
ARG NODE_VERSION=24
# Debian release of the base image. bookworm is the default and owns the
# unsuffixed tags; trixie is built alongside it and only ever gets -trixie tags.
ARG DEBIAN_RELEASE=bookworm

# Use the ARG to pull the correct base image
FROM php:${PHP_VERSION}-${IMAGE_TYPE}-${DEBIAN_RELEASE}

LABEL org.opencontainers.image.title="php" \
      org.opencontainers.image.description="PHP-FPM and CLI with 57 extensions, Composer, WP-CLI, Node.js and Supervisor" \
      org.opencontainers.image.source="https://github.com/morsalin1342/php-docker" \
      org.opencontainers.image.licenses="MIT"

# Re-declare ARGs to be available in subsequent build stages
ARG PHP_VERSION
ARG IMAGE_TYPE
ARG NODE_VERSION
ARG DEBIAN_RELEASE

# ==> 1. Install System Dependencies & Node.js <==
# Install essential system packages and Node.js in a single layer for efficiency.
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        default-mysql-client \
        dnsutils \
        git \
        gosu \
        jq \
        less \
        libcap2-bin \
        libfcgi-bin \
        libnss3-tools \
        msmtp \
        msmtp-mta \
        netcat-openbsd \
        procps \
        unzip \
        wget \
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
    IPE_ICU_EN_ONLY=1 install-extensions.sh ${PHP_VERSION} && \
    rm /tmp/installable-extensions /tmp/supported-extensions

# ==> 3. Install Global PHP Tools <==
# Copy Composer from the official image
COPY --from=composer:2.10.2 /usr/bin/composer /usr/local/bin/composer

# Add WP-CLI (WordPress Command Line Interface)
ADD --chmod=0755 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp

# ==> 4. Configure PHP <==
# Use the production php.ini configuration file
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
# No sendmail_path is baked in: PHP's compiled default (/usr/sbin/sendmail -t -i)
# already resolves to msmtp via msmtp-mta, so mail() works once a deployer supplies
# an SMTP relay in /etc/msmtprc. No php.ini override needed.
