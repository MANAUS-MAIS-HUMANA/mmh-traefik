#!/bin/bash

# ./compose.sh "up -d" dev

# Descrição
# - $0 = ./compose.sh
# - $1 = "up -d"
# - $2 = dev

echo "Running docker-compose $1..."

if [[ ! -d ./front ]]; then
    git clone https://github.com/MANAUS-MAIS-HUMANA/mmh-web.git front

    yes | cp ./docker/node/Dockerfile ./front/

    echo "Running npm install in front"
    cd front && npm install --silent && cd ..
fi

if [[ ! -d ./back ]]; then
    git clone https://github.com/MANAUS-MAIS-HUMANA/mmh-service.git back

    echo "Running permissions in back"
    cd back && sudo chmod -R 755 storage && sudo chmod -R 755 bootstrap/cache/ && cd ..
fi

case "$2" in
    dev|"")
        yes | cp .env-dev .env
        yes | cp ./docker/nginx/back/default-dev.conf ./docker/nginx/back/default.conf

        rm -f acme.json

        sudo docker-compose $1 --remove-orphans
    ;;
    prod)
        yes | cp .env-prod .env
        yes | cp ./docker/nginx/back/default-prod.conf ./docker/nginx/back/default.conf

        touch acme.json
        sudo chmod 600 acme.json

        sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml $1 --remove-orphans
esac
