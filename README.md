# Traefik - Estrutura de proxy reverso

Estrutura em containers usando o [Traefik v1.7](https://docs.traefik.io/v1.7), tendo como dependências os containers listados:

|                                                              | Versão                                                                                                                              |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| [NGINX](https://hub.docker.com/_/nginx)                      | 1.17-alpine                                                                                                                         |
| [PHP](https://hub.docker.com/_/php)                          | [7.4.4-fpm-alpine](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links) |
| [NodeJS](https://hub.docker.com/_/node)                      | 12.16.1-alpine3.9                                                                                                                   |
| [MySql](https://hub.docker.com/_/mysql)                      | 5.7                                                                                                                                 |
| [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin) | latest                                                                                                                              |

- Estrutura criada para atender em ambiente de **Desenvolvimento**, como também, em ambiente de **Produção**.
- Para seguir os passados de utilização, você deve ter instalado em seu computador o [Docker](https://docs.docker.com/engine/install/).
- E para sistemas Linux, além do Docker, também é necessário o [Docker Compose](https://docs.docker.com/compose/install/).

> _**Obs.:** Não feram feitos teste em ambiente de `produção`._

### Para utilizar essa estrutura, alguns passos devem serem feitos:

1.  Com base no `.env-example`, crie dois `.env`, sendo um como `.env-dev` e o outro como `.env-prod`
    > Observe que existem parâmetros que são **obrigatórios** para cada tipo de `.env`.
2.  Gerar a senha de autenticação ao **dashboard** do traefik, copie e cole no parâmetro `TRAEFIK_AUTH` do `.env-*`

    > Observe que para gerar a senha, é necessário ter instalado o pacote `apache2-utils`

    ```bash
    # comando
    htpasswd -nb usuario senha

    # saida
    usuario:$apr1$ImIUZeZB$cP2ieEvGmSoNH4Cyt1zHH.
    ```

3.  Na pasta raiz, existe um arquivo chamado `Makefile`, ele executa algumas validações e ações para que os containers possam subir, seguem comandos

    ```bash
    # modo: desenvolvimento
    # Primeiro build
    make start-dev

    # Subir containers após primeiro build
    make up-dev

    # modo: produção
    make start-prod

    # Derrubar containers
    make down
    ```

Seguido todos os passos acima descritos, você já deve ter acesso ao **dashboard** do traefik através da url `traefik.localhost`, informe usuário e senha conforme explicado no _passo 2_, e logo você verá uma coluna chamada **FRONTENDS**, lá estarão listadas as url's para acesso a cada um dos containers disponíveis.

### Manipulação do banco de dados em ambiente local

Comando para executar uma migração:
```
make db-migrate
```

Comando para executar o rollback de uma migração:
```
make db-rollback
```

Comando para criar uma nova migração:
```
make db-migrate-make ARGS="nome da migração"
```

Comando para acessar o banco de dados no terminal:
```
make db-shell
```

### Outros comandos úteis

Comando para entrar no shell do container `back`:
```
make shell
```

### Visão geral da estrutura do projeto

```
    traefik
    |___docker
    |    |___mysql
    |    |   |  Dockerfile
    |    |   |  my.cnf
    |    |
    |    |___nginx
    |        |___back
    |        |    |   default-dev.conf
    |        |    |   default-prod.conf
    |        |
    |        |___front
    |        |    |   default.conf
    |        |
    |        |   Dockerfile
    |
    |________node
    |        |   Dockerfile
    |
    |________php-fpm
    |        |   Dockerfile
    |        | 	 entrypoint.sh
    |
    |   .env-example
    |   .gitignore
    |   docker-compose.override.yml
    |   docker-compose.prod.yml
    |   docker-compose.yml
    |   Makefile
    |   README.md
    |
```
