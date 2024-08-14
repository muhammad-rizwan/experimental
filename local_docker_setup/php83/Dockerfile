FROM php:8.3-fpm-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions xdebug redis @composer pdo_mysql mysqli

WORKDIR /var/www

RUN apk --no-cache add \
    git \
    bash \
    openssh \
    openssh-client \
    nano

COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./www-data.conf /usr/local/etc/php-fpm.d/www-data.conf

CMD php-fpm
