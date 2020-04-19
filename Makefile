.PHONY: start-dev
start-dev: front back dev network-external build-no-cache up-dev

.PHONY: start-prod
start-prod: front back prod network-external build-no-cache up-prod

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

.PHONY: network-external
network-external:
	docker network inspect mmh_external > /dev/null 2>&1 || docker network create --driver bridge mmh_external

.PHONY: up-dev
up-dev:
	@docker-compose up

.PHONY: up-prod
up-prod:
	@docker-compose -f docker-compose.yml -f docker-compose.prod.yml up

.PHONY: down
down:
	@docker-compose down

.PHONY: db-migrate
db-migrate:
	@docker-compose exec back ./artisan migrate

.PHONY: db-migrate-make
db-migrate-make:
	@docker-compose exec back ./artisan make:migration ${ARGS}

.PHONY: db-refresh
db-refresh:
	@docker-compose exec back ./artisan migrate:refresh

.PHONY: db-rollback
db-rollback:
	@docker-compose exec back ./artisan migrate:rollback

.PHONY: db-shell
db-shell:
	@docker-compose exec mysql mysql -u ${USER} -p

.PHONY: shell
shell:
	@docker-compose exec back bash
