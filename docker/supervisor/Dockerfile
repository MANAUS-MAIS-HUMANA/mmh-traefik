FROM php:7.4.4-fpm-alpine3.11

RUN apk --update add build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  pcre-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev \
  oniguruma-dev \
  supervisor

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml pcntl
RUN pecl channel-update pecl.php.net \
    && pecl install memcached mcrypt-1.0.1 mongodb \
    && docker-php-ext-enable memcached mongodb

ARG USERNAME=mmh

RUN addgroup -g 1000 $USERNAME \
    && adduser -D -G $USERNAME -u 1000 $USERNAME

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

WORKDIR /etc/supervisor/conf.d/
