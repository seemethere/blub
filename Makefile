GOPATH=$(shell go env GOPATH)

VERSION:=$(shell cat VERSION)
ENGINE_PATH:=$(GOPATH)/src/github.com/docker/docker
CLI_PATH:=$(GOPATH)/src/github.com/docker/cli
PACKAGING_PATH:=$(CURDIR)/docker-ce-packaging

%:
	$(MAKE) -e -C $(PACKAGING_PATH) ENGINE_DIR="$(ENGINE_PATH)" CLI_DIR="$(CLI_PATH)" VERSION="$(VERSION)" $@

$(CLI_PATH)/build/docker:
	make -C $(CLI_PATH) -f docker.Makefile binary

test-integration: $(CLI_PATH)/build/docker
	make -e -C $(ENGINE_PATH) TEST_CLIENT_BINARY="$<" test-integration
