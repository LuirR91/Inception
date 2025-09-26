include ./srcs/.env

all : up

up:
	mkdir -p /home/$(USER)/data/$(USER)$(DOMAIN_SUFFIX)/mariadb
	mkdir -p /home/$(USER)/data/$(USER)$(DOMAIN_SUFFIX)/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down --rmi all -v
	sudo rm -rf /home/$(USER)/data/$(USER)$(DOMAIN_SUFFIX)

re: down up

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml start

status:
	docker ps -p

mariadb:
	sudo docker exec -it mariadb bash

nginx:
	sudo docker exec -it nginx bash

wordpress:
	sudo docker exec -it wordpress bash

mariadb_data:
	docker exec -it mariadb mysql -uroot -p

fclean:
	@docker system prune -a -f
	@docker image prune -a -f
	@docker container prune -f
	@docker builder prune -a -f
	@docker network prune -f

# curl -v http://luiribei.42.fr
# sudo ss -ltnp | grep ':80'


#	docker exec -it mariadb mysql -uroot -p
#	SHOW DATABASES;
#	USE `luiribei.42.fr`;
#	SHOW TABLES;
#	SELECT * FROM table_name;
