.DEFAULT_GOAL := run-server

run-server:
	@docker-compose up -d

stop-server:
	@docker-compose down -v
