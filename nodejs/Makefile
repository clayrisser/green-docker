CWD := $(shell pwd)
TAG := nodejs
PORT := 3000
IMAGE := "codejamninja/green-docker:$(TAG)"
SOME_CONTAINER := $(shell echo some-$(IMAGE) | sed 's/[^a-zA-Z0-9]//g')
DOCKERFILE := $(CWD)/$(TAG)/Dockerfile

.PHONY: all
all: clean build

.PHONY: build
build:
	@docker build -t $(IMAGE) -f $(DOCKERFILE) $(CWD)
	@echo ::: BUILD :::

.PHONY: pull
pull:
	@docker pull $(IMAGE)
	@echo ::: PULL :::

.PHONY: push
push:
	@docker push $(IMAGE)
	@echo ::: PUSH :::

.PHONY: run
run:
	@docker run --name run$(SOME_CONTAINER) -p $(PORT):$(PORT) --rm $(IMAGE)

.PHONY: ssh
ssh:
	@docker run --name ssh$(SOME_CONTAINER) --rm -it --entrypoint /bin/sh $(IMAGE)

.PHONY: essh
essh:
	@docker exec run$(SOME_CONTAINER) /bin/sh

.PHONY: clean
clean:
	-@ rm -rf ./stuff/to/clean &>/dev/null || true
	@echo ::: CLEAN :::
