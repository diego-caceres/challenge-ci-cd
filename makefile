include ../../../make.inc

# Carga variables del .env si existe
ifneq (,$(wildcard .env))
	include .env
	export
endif

# Construir DOCKER_IMAGE_NAME usando las variables
HOSTNAME := $(LOCATION)-docker.pkg.dev
DOCKER_IMAGE_NAME := $(HOSTNAME)/$(PROJECT_ID)/$(REPOSITORY)/$(IMAGE_NAME):$(IMAGE_TAG)

build_docker_image:
	docker build -t $(DOCKER_IMAGE_NAME) -f Dockerfile .

run_docker_image:
	docker run --rm -it -e PORT=${PORT} -p ${PORT}:${PORT} $(DOCKER_IMAGE_NAME)

push_docker_image:
	docker push "$(DOCKER_IMAGE_NAME)"

deploy_docker_image:
	gcloud run deploy fastapi \
	--image "$(DOCKER_IMAGE_NAME)" \
	--region=europe-west1 \
	--allow-unauthenticated
