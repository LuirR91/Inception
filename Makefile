include ./srcs/.env

all : up

up:
	mkdir -p /home/$(USER)/data/$(USER)$(DOMAIN_SUFFIX)/mariadb
	mkdir -p /home/$(USER)/data/$(USER)$(DOMAIN_SUFFIX)/wordpress
	docker compose -f ./srcs/docker-compose.yml up

down:
	docker compose -f ./srcs/docker-compose.yml down --rmi all -v
	sudo rm -rf /home/$(USER)/data/$(USER)$(DOMAIN_SUFFIX)

recreate: down up

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml start

status:
	docker ps

mariadb:
	sudo docker exec -it mariadb bash

nginx:
	sudo docker exec -it nginx bash

wordpress:
	sudo docker exec -it wordpress bash