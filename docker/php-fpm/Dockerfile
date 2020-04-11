# Desenvolvimento
FROM php:7.4.4-fpm-alpine3.11 AS development

ARG USERNAME=codese

RUN adduser -D "$USERNAME"

WORKDIR /var/www

RUN rm -rf /var/www/html \
    && apk add --no-cache openssl bash nano mysql-client \
    && docker-php-ext-install pdo pdo_mysql bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

USER $USERNAME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


# Produção
FROM php:7.4.4-fpm-alpine:3.11 AS production

WORKDIR /var/www

RUN rm -rf /var/www/html \
    && apk add --no-cache mysql-client \
    && docker-php-ext-install pdo pdo_mysql bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000

CMD ["php-fpm"]
