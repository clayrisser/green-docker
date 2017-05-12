SHELL := /bin/bash
CWD := $(shell readlink -en $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))
IMAGE := "jamrizzi/green-docker:latest"
SOME_CONTAINER := $(shell echo some-$(IMAGE) | sed 's/[^a-zA-Z0-9]//g')
DOCKERFILE := $(CWD)/Dockerfile

.PHONY: all
all: clean fetch_dependancies build

.PHONY: build
build:
	docker build -t $(IMAGE) -f $(DOCKERFILE) $(CWD)
	$(info built $(IMAGE))

.PHONY: pull
pull:
	docker pull $(IMAGE)
	$(info pulled $(IMAGE))

.PHONY: push
push:
	docker push $(IMAGE)
	$(info pushed $(IMAGE))

.PHONY: run
run:
	docker run --name $(SOME_CONTAINER) --rm $(IMAGE)
	$(info ran $(IMAGE))

.PHONY: ssh
ssh:
	dockssh $(IMAGE)

.PHONY: essh
essh:
	dockssh -e $(SOME_CONTAINER)

.PHONY: clean
clean:
	# rm -rf ./stuff/to/clean
	$(info cleaned)

.PHONY: fetch_dependancies
fetch_dependancies: docker
	$(info fetched dependancies)
.PHONY: docker
docker:
ifeq ($(shell whereis docker), $(shell echo docker:))
	curl -L https://get.docker.com/ | bash
endif
	$(info fetched docker)
