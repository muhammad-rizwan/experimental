FROM php:7.4-fpm-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions xdebug redis @composer pdo_mysql

WORKDIR /var/www

# adding some basic 
RUN apk --no-cache add \
    git \
    bash \
    openssh \
    openssh-client \
    nano

COPY ./php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./www-data.conf /usr/local/etc/php-fpm.d/www-data.conf

CMD php-fpm
