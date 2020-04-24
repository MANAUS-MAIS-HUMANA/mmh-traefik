# Desenvolvimento
FROM nginx:1.17-alpine AS development

RUN apk add openssl bash

ARG UPSTREAM_CONTAINER=back
ARG UPSTREAM_PORT=9000

RUN echo "upstream php-upstream { server ${UPSTREAM_CONTAINER}:${UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

COPY ./back/default.conf /etc/nginx/conf.d

EXPOSE 80


# Produção
FROM nginx:1.17-alpine AS production

RUN rm /etc/nginx/conf.d/default.conf

COPY ./back/default.conf /etc/nginx/conf.d

EXPOSE 443
