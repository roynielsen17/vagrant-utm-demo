# Load environment variables from .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Variables for Docker operations
IMAGE_NAME = ${DOCKERHUB_USERNAME}/one2n-bootcamp
TAG ?= 1.6.0
NETWORK_NAME = flask_network

# Default DB_HOST (can be overridden)
DB_HOST ?= mysql_container

# Ensure environment variables are loaded
check_env:
	@echo "Checking environment variables..."
	@if [ ! -f ".env" ]; then \
		echo "Error: .env file not found."; \
		exit 1; \
	fi
	@echo "Using environment variables from .env file"

# Build the Docker images
build_flask_images:
	@echo "Building Flask API containers..."
	@API_VERSION=$(TAG) docker-compose build api1 api2

# Start the MySQL container using Docker Compose
run_db:
	@echo "Starting MySQL container using Docker Compose"
	docker-compose up -d mysql && sleep 10

# Start the NGINX container
run_nginx:
	@docker-compose up -d nginx

# Start the Flask API containers using Docker Compose
run_flask_containers:
	@echo "Starting Flask API containers..."
	@API_VERSION=$(TAG) DB_URL=mysql://root:${MYSQL_ROOT_PASSWORD}@${DB_HOST}:3306/${MYSQL_DATABASE} \
	docker-compose up -d api1 api2

# Full deployment target
deploy_api_service_to_vagrant: check_env build_flask_images run_db run_flask_containers run_nginx
	@echo "API Services, NGINX, and MySQL deployed successfully."