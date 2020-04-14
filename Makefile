.PHONY: start-dev
start-dev: front back dev up-dev

.PHONY: start-dev--no-cache
start-dev--no-cache: front back dev build-no-cache up-dev

.PHONY: start-prod
start-prod: front back prod build-no-cache up-prod

.PHONY: front
front:
	if [ ! -d "./front" ]; then \
		git clone https://github.com/MANAUS-MAIS-HUMANA/mmh-web.git front; \
		cp ./docker/node/Dockerfile ./front/; \
	fi

.PHONY: back
back:
	if [ ! -d "./back" ]; then \
		git clone https://github.com/MANAUS-MAIS-HUMANA/mmh-service.git back; \
		cp ./docker/php-fpm/Dockerfile ./back/; \
		cp ./docker/php-fpm/entrypoint.sh ./back/; \
		chmod -R 755 ./back/storage ./back/bootstrap/cache/; \
	fi

.PHONY: dev
dev:
	cp .env-dev .env;
	cp ./docker/nginx/back/default-dev.conf ./docker/nginx/back/default.conf;
	rm -f acme.json;

.PHONY: prod
prod:
	cp .env-prod .env;
	cp ./docker/nginx/back/default-prod.conf ./docker/nginx/back/default.conf;
	touch acme.json;
	chmod 600 acme.json;

.PHONY: build
build:
	@docker-compose build

.PHONY: build-no-cache
build-no-cache:
	@docker-compose build --no-cache

.PHONY: up-dev
up-dev:
	@docker-compose up

.PHONY: up-prod
up-prod:
	@docker-compose -f docker-compose.yml -f docker-compose.prod.yml up

.PHONY: down
down:
	@docker-compose down
