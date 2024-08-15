FROM alpine:3.19

ARG PHP_VERSION=83 \
    DB_NAME \
    DB_USER \
    DB_PASS \
    ADMIN_USER \
    ADMIN_PASSWORD \
    USER_NAME \
    USER_PASSWORD \
    ADMIN_EMAIL \
    USER_EMAIL

RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-redis \
    mysql-client \
    wget \
    curl \
    unzip && \
    addgroup -S www-data || true && adduser -S -G www-data www-data && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = www-data|g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s|user = nobody|user = www-data|g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s|group = nobody|group = www-data|g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*



# Create a symbolic link for php
RUN ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php

# Add PHP binary directory to PATH
ENV PATH="/usr/bin:${PATH}"

WORKDIR /var/www
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip


COPY ./requirements/wordpress/conf/wp-config-create.sh .
RUN sh wp-config-create.sh && rm wp-config-create.sh

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp \
    && chown www-data:www-data /usr/local/bin/wp


COPY ./requirements/wordpress/conf/setup.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/setup.sh
CMD ["/usr/local/bin/setup.sh"]



