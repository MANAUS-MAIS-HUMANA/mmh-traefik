#!/bin/bash

composer install
php artisan package:discover --ansi

if [[ ! -d ./vendor ]]; then
    php -r "file_exists('.env') || copy('.env.example', '.env');"
    php artisan key:generate --ansi
fi

php artisan config:clear

php-fpm
