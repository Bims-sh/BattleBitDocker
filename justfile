TAG := "battlebit:local"

# Default target
default: build

build:
    @echo "Building image '{{TAG}}'..."
    docker compose build

run:
    @echo "Running '{{TAG}}' (foreground)..."
    docker compose up

rund:
    @echo "Running '{{TAG}}' (detached)..."
    docker compose up -d
    @echo "Started. Use 'just logs' to follow logs."

shell:
    @echo "Opening shell inside image..."
    docker compose run --rm --entrypoint /bin/sh battlebit

clean:
    @echo "Removing containers and image..."
    docker compose down --rmi local

logs:
    docker compose logs -f

stop:
    @echo "Stopping container..."
    docker compose down