include build.vars

IMAGE_REPO := aksw/fuseki-vanilla
SYNC_FILES := README.md example/docker-compose.yaml

.DEFAULT_GOAL := build
.PHONY: sync-version build

sync-version:
	@sed -i.bak "s/^ARG FUSEKI_VERSION=.*/ARG FUSEKI_VERSION=$(FUSEKI_VERSION)/" Dockerfile && rm -f Dockerfile.bak
	@for f in $(SYNC_FILES); do \
	  sed -i.bak \
	    -e "s|$(IMAGE_REPO):[0-9][0-9.-]*|$(IMAGE_REPO):$(IMAGE_TAG)|g" \
	    -e "s|^Current \(image \)\?version: .*|Current image version: **$(IMAGE_TAG)** (Fuseki $(FUSEKI_VERSION))|" \
	    "$$f" && rm -f "$$f.bak"; \
	done
	@echo "synced: Dockerfile <- FUSEKI_VERSION=$(FUSEKI_VERSION), docs <- IMAGE_TAG=$(IMAGE_TAG)"

build: sync-version
	docker build --no-cache -t $(IMAGE_REPO):$(IMAGE_TAG) .
