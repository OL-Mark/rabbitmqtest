build:
	docker compose --file docker-compose.yml build

up:
	bundle install && docker compose --file docker-compose.yml --env-file .env up

down:
	docker compose --file docker-compose.yml down

