#!/bin/bash

if [[ ! -d ./vendor ]]; then
    composer install
    php artisan package:discover --ansi
    php -r "file_exists('.env') || copy('.env.example', '.env');"
    php artisan key:generate --ansi
fi

php-fpm
