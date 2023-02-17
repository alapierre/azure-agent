IMAGE_NAME=lapierre/azure-agent
IMAGE_VERSION=0.0.9
AGENT_VERSION=2.214.2

build:
	docker build --build-arg AGENT_VERSION=$(AGENT_VERSION) -t $(IMAGE_NAME):$(IMAGE_VERSION) .
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(IMAGE_NAME):latest

push:
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)
	docker push $(IMAGE_NAME):latest
