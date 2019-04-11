IMAGE_NAME = $(DOCKER_USERNAME)/emacs-make

build:
	docker build -t $(IMAGE_NAME):$(EMACS_VERSION) --build-arg EMACS_VERSION=$(EMACS_VERSION) .

login:
	@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)

push: login
	docker push $(IMAGE_NAME):$(EMACS_VERSION)

.PHONY: build login push
