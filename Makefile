-include .env
POSTGRES_USER ?= postgres
POSTGRES_DB ?= db_labs

PSQL = docker compose exec -T db psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

.PHONY: up down reset psql test migrate lab2 lab2-queries lab2-dml migrate

up:
	docker compose up -d --wait

down:
	docker compose down

reset:
	docker compose down -v
	docker compose up -d --wait

psql:
	docker compose exec db psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

test:
	$(PSQL) < Lab1/sql/constraints_test.sql

lab2: up

lab2-queries:
	$(PSQL) -v ON_ERROR_STOP=1 < labs/lab2/queries.sql

lab2-dml:
	$(PSQL) -v ON_ERROR_STOP=1 < labs/lab2/dml.sql

migrate:
	docker compose exec -T db psql -U postgres -d db_labs -v ON_ERROR_STOP=1 < Lab1/sql/migration.sql
