# Desenvolvimento
FROM php:7.4.4-fpm-alpine3.11 AS development

WORKDIR /var/www

ARG USERNAME=codese

RUN addgroup -g 1000 "${USERNAME}Group" \
    && adduser -u 1000 -G "${USERNAME}Group" -s /bin/sh -D $USERNAME

RUN rm -rf /var/www/html \
    && apk add --no-cache openssl bash nano mysql-client \
    && docker-php-ext-install pdo pdo_mysql bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

COPY . .

USER $USERNAME

EXPOSE 9000

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
