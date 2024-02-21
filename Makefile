.DEFAULT_GOAL: build-all

K8S_VERSION          ?= $(shell kubectl version --short | grep -i server | cut -d" " -f3 | cut -c2-)
KIND_IMAGE           ?= kindest/node:$(K8S_VERSION)
KIND_NAME            ?= kind
USE_CONFIG           ?= standard

TOOLS_DIR                          := $(PWD)/.tools
KIND                               := $(TOOLS_DIR)/kind
KIND_VERSION                       := v0.22.0
HELM                               := $(TOOLS_DIR)/helm
HELM_VERSION                       := v3.10.1
TOOLS                              := $(KIND) $(HELM)

$(KIND):
	@echo Install kind... >&2
	@GOBIN=$(TOOLS_DIR) go install sigs.k8s.io/kind@$(KIND_VERSION)

$(HELM):
	@echo Install helm... >&2
	@GOBIN=$(TOOLS_DIR) go install helm.sh/helm/v3/cmd/helm@$(HELM_VERSION)

.PHONY: install-tools
install-tools: $(TOOLS)

.PHONY: clean-tools
clean-tools: 
	@echo Clean tools... >&2
	@rm -rf $(TOOLS_DIR)

##################
# CHAINSAW TESTS #
##################

.PHONY: test-chainsaw
test-chainsaw:  
	@echo Running chainsaw tests... >&2
	@chainsaw test --config .chainsaw-config.yaml

## Create kind cluster
.PHONY: kind-create-cluster
kind-create-cluster: $(KIND) 
	@echo Create kind cluster... >&2
	@$(KIND) create cluster --name $(KIND_NAME) --image $(KIND_IMAGE)

## Delete kind cluster
.PHONY: kind-delete-cluster
kind-delete-cluster: $(KIND) 
	@echo Delete kind cluster... >&2
	@$(KIND) delete cluster --name $(KIND_NAME)

## Deploy Enterprise Kyverno
.PHONY: kind-deploy-kyverno
kind-deploy-kyverno: $(HELM) 
	@echo Install kyverno chart... >&2
	@$(HELM) repo add nirmata https://nirmata.github.io/kyverno-charts
	@$(HELM) repo update
	@$(HELM) install kyverno nirmata/kyverno -n kyverno --create-namespace --version=$(N4K_VERSION)

## Check Kyverno status 
.PHONY: wait-for-kyverno
wait-for-kyverno: 
	@echo Check kyverno status to be ready... >&2
	@kubectl wait --namespace kyverno --for=condition=ready pod --all --timeout=180s

#####################
# Kyverno CLI TESTS #
#####################

.PHONY: get-kyverno-binary
get-kyverno-binary: 
	@echo Download kyverno binary ... >&2
	@curl -LO https://github.com/nirmata/kyverno/releases/download/$(N4K_BINARY_VERSION)/kyverno-cli_$(N4K_BINARY_VERSION)_linux_x86_64.tar.gz
	@tar -xvf kyverno-cli_$(N4K_BINARY_VERSION)_linux_x86_64.tar.gz

.PHONY: run-cli-test
run-cli-test: 
	@echo wait kyverno pod status installation... >&2
	@./kyverno test .
