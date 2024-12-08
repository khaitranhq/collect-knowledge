# Docker Compose containers depend on other containers healthcheck

Tags: Docker
Application: Docker management

## Conditions:

- `service_started`
- `service_healthy`. This specifies that a dependency is expected to be “healthy”, which is defined with `healthcheck`, before starting a dependent service.
- `service_completed_successfully`. This specifies that a dependency is expected to run to successful completion before starting a dependent service.

## Example

```yaml
services:
  db:
    image: postgres:16.2
    environment:
      - POSTGRES_PASSWORD=${POSTGRESQL_PASSWORD:-postgres}
      - POSTGRES_USERNAME=${POSTGRESQL_USERNAME:-postgres}
      - POSTGRES_DB=${POSTGRESQL_DB_NAME:-postgres}
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready", "-d", "$POSTGRESQL_DB_NAME"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      # Uncomment the following line if you want to persist data
      # - ./db/data:/var/lib/postgresql/data
      - ./db/init:/docker-entrypoint-initdb.d/
    restart: on-failure

  db.pgweb:
    image: sosedoff/pgweb:0.14.3
    environment:
      - PGWEB_DATABASE_URL=postgres://${POSTGRESQL_USERNAME:-postgres}:${POSTGRESQL_PASSWORD:-postgres}@db:5432/${POSTGRESQL_DB_NAME:-postgres}?sslmode=disable
    ports:
      - "5679:8081"
    depends_on:
      db:
        condition: service_healthy
    restart: on-failure

  db.migration:
    build:
      context: ..
      dockerfile: database/Dockerfile
    environment:
      - POSTGRESQL_HOST=${POSTGRESQL_HOST:-db}
      - POSTGRESQL_PORT=${POSTGRESQL_PORT:-5432}
      - POSTGRESQL_USERNAME=${POSTGRESQL_USERNAME:-postgres}
      - POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD:-postgres}
      - POSTGRESQL_DB_NAME=${POSTGRESQL_DB_NAME-postgres}
      - DATABASE_URL=postgres://${POSTGRESQL_USERNAME:-postgres}:${POSTGRESQL_PASSWORD:-postgres}@db:5432/${POSTGRESQL_DB_NAME-postgres}
    depends_on:
      db:
        condition: service_healthy
    restart: no

  api:
    build:
      context: ..
      dockerfile: apps/api/Dockerfile
    environment:
      - ENVIRONMENT=${ENVIRONMENT:-local}
    depends_on:
      db:
        condition: service_healthy
      db.migration:
        condition: service_completed_successfully
    ports:
      - 5680:${GATEWAY_PORT}
    restart: no
```
