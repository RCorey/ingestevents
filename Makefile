IMAGE_NAME ?= ingestevents
CONTAINER_NAME ?= ingestevents
VAR_FILE = vars.env
PORTS = -p 80:80

# HELP
#Reference: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
#Auto document help for each makefile section
.PHONY: help docker docker-run

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
docker: ## Builds the container
	docker build -t $(IMAGE_NAME) .
docker-run: docker ## Builds and runs the container detached
	docker run --env-file $(VAR_FILE) $(PORTS) --name $(CONTAINER_NAME) $(IMAGE_NAME)
docker-run-d: docker ## Builds and runs the container detached
	docker run -d --env-file $(VAR_FILE) $(PORTS) --name $(CONTAINER_NAME) $(IMAGE_NAME)
docker-shell: docker ## Build the container and execute a shell overriding the default entrypoint
	docker run --rm --name $(CONTAINER_NAME) -i -t --env-file $(VAR_FILE) $(PORTS) --entrypoint /bin/bash $(IMAGE_NAME)
docker-test: docker ## Build the container and run tests
	docker run -i -t --env-file $(VAR_FILE) $(PORTS) $(IMAGE_NAME) test