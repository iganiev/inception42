export COMPOSE_HTTP_TIMEOUT=200

name = inception
all:
	@printf "Launch configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

build:
	@printf "Building configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

up:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env up -d

re: down
	@printf "Rebuild configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@sudo find ~/data/wordpress/ -mindepth 1 -delete
	@sudo find ~/data/mariadb/ -mindepth 1 -delete
fclean:
	@printf "Total clean of all configurations docker\n"
	@docker stop $$(docker ps -qa) # Stop all running containers
	@docker rm $$(docker ps -qa) # Remove all containers
	@docker volume rm $$(docker volume ls -q) # Remove all volumes
	@docker volume prune --force
	@docker network prune --force


.PHONY	: all build down re clean fclean
