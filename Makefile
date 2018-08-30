.PHONY: help

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
GIT_REVISION ?= `git rev-parse --short HEAD`
GIT_REVISION_ALL_COUNT ?= `git rev-list --all --count`
GIT_REVISION_BRANCH_COUNT ?= `git rev-list --count HEAD`
GIT_BRANCH ?= `git rev-parse --abbrev-ref HEAD`
DATE_YYYYMMDD ?= `date +%Y%m%d`
RELEASE_NAME ?= "$(APP_NAME)_$(APP_VSN)+$(DATE_YYYYMMDD)-$(GIT_BRANCH)-$(GIT_REVISION_BRANCH_COUNT)-$(GIT_REVISION)"
RELEASE_FOLDER ?= ".deliver/releases"
DOCKER_RELEASE_NAME ?= "$(APP_VSN)-$(GIT_REVISION)"
EXTRACT_CONTAINER ?= "$(APP_NAME)_extract"

help:
	@echo "$(RELEASE_NAME)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

release: ## Build the Release file
	@echo "BUILDING: $(RELEASE_NAME)"
	docker build --no-cache \
		--build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		--target build -t $(APP_NAME):build .
	docker container create --name $(EXTRACT_CONTAINER) $(APP_NAME):build
	docker container cp \
		$(EXTRACT_CONTAINER):/opt/app/_build/prod/rel/$(APP_NAME)/releases/$(APP_VSN)/$(APP_NAME).tar.gz \
		$(RELEASE_FOLDER)/$(RELEASE_NAME).release.tar.gz
	docker container rm -f $(EXTRACT_CONTAINER)
	@echo "BUILT: $(RELEASE_FOLDER)/$(RELEASE_NAME).release.tar.gz"

build: ## Build the Docker image
	docker build --no-cache \
		--build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(APP_NAME):$(DOCKER_RELEASE_NAME) \
		-t $(APP_NAME):latest .

run: ## Run the app in Docker
	docker run --env-file config/docker.env \
		-p 4000:4000 -p 14000:14000 -p 24000:24000 \
		--rm -it $(APP_NAME):latest
