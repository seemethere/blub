GOPATH=$(shell go env GOPATH)

VERSION:=$(shell cat VERSION)
ENGINE_DIR:=$(GOPATH)/src/github.com/docker/docker
CLI_DIR:=$(GOPATH)/src/github.com/docker/cli
PACKAGING_DIR:=$(CURDIR)/packaging

MAKE_VARIABLES=VERSION="$(VERSION)" ENGINE_DIR="$(ENGINE_DIR)" CLI_DIR="$(CLI_DIR)"

all:
	$(MAKE) -e -C $(PACKAGING_DIR) $(MAKE_VARIABLES) DOCKER_BUILD_PKGS=static-linux static

%:
	$(MAKE) -e -C $(PACKAGING_DIR) $(MAKE_VARIABLES) $@

$(CLI_DIR)/build/docker:
	make -C $(CLI_DIR) -f docker.Makefile binary

test-integration: $(CLI_DIR)/build/docker
	make -e -C $(ENGINE_DIR) VERSION="$(VERSION)" TEST_CLIENT_BINARY="$<" test-integration
