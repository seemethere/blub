GOPATH=$(shell go env GOPATH)

VERSION:=$(shell cat VERSION)
ENGINE_DIR:=$(GOPATH)/src/github.com/docker/docker
CLI_DIR:=$(GOPATH)/src/github.com/docker/cli
PACKAGING_DIR:=$(CURDIR)/packaging

MAKE_VARIABLES=VERSION="$(VERSION)" ENGINE_DIR="$(ENGINE_DIR)" CLI_DIR="$(CLI_DIR)"

all:
	$(MAKE) -e -C $(PACKAGING_DIR) $(MAKE_VARIABLES) DOCKER_BUILD_PKGS=static-linux static

.PHONY: clean
clean:
	$(MAKE) -e -C $(PACKAGING_DIR) clean
	$(MAKE) -e -C $(ENGINE_DIR) clean
	$(MAKE) -e -C $(CLI_DIR) -f docker.Makefile clean

.PHONY: test
test: test-unit test-integration

.PHONY: test-unit
test-unit: cli-test-unit engine-test-unit

.PHONY: cli-test-unit
cli-test-unit:
	$(MAKE) -e -C $(CLI_DIR) -f docker.Makefile test-unit

.PHONY: engine-test-unit
engine-test-unit:
	$(MAKE) -e -C $(ENGINE_DIR) VERSION="$(VERSION)" test-unit

$(CLI_DIR)/build/docker:
	make -C $(CLI_DIR) -f VERSION="$(VERSION)" docker.Makefile binary

.PHONY: test-integration
test-integration: engine-test-integration cli-test-integration

.PHONY: engine-test-integration
engine-test-integration: $(CLI_DIR)/build/docker
	make -e -C $(ENGINE_DIR) VERSION="$(VERSION)" TEST_CLIENT_BINARY="$<" test-integration

.PHONY: cli-test-integration
cli-test-integration:
	make -e -C $(CLI_DIR) VERSION="$(VERSION)" test-e2e

packaging-%:
	$(MAKE) -e -C $(PACKAGING_DIR) $(MAKE_VARIABLES) $(subst packaging-,,$@)
