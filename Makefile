.DEFAULT_GOAL: build-all

K8S_VERSION          ?= $(shell kubectl version --short | grep -i server | cut -d" " -f3 | cut -c2-)
KIND_IMAGE           ?= kindest/node:v1.25.2
KIND_NAME            ?= kind
USE_CONFIG           ?= standard

TOOLS_DIR                          := $(PWD)/.tools
KIND                               := $(TOOLS_DIR)/kind
KIND_VERSION                       := v0.17.0
HELM                               := $(TOOLS_DIR)/helm
HELM_VERSION                       := v3.10.1
KUTTL                              := $(TOOLS_DIR)/kubectl-kuttl
KUTTL_VERSION                      := v0.0.0-20230108220859-ef8d83c89156
TOOLS                              := $(KIND) $(HELM) $(KUTTL)

$(KIND):
	@echo Install kind... >&2
	@GOBIN=$(TOOLS_DIR) go install sigs.k8s.io/kind@$(KIND_VERSION)

$(HELM):
	@echo Install helm... >&2
	@GOBIN=$(TOOLS_DIR) go install helm.sh/helm/v3/cmd/helm@$(HELM_VERSION)

$(KUTTL):
	@echo Install kuttl... >&2
	@GOBIN=$(TOOLS_DIR) go install github.com/kyverno/kuttl/cmd/kubectl-kuttl@$(KUTTL_VERSION)

.PHONY: install-tools
install-tools: $(TOOLS)

.PHONY: clean-tools
clean-tools: 
	@echo Clean tools... >&2
	@rm -rf $(TOOLS_DIR)

###############
# KUTTL TESTS #
###############

.PHONY: test-kuttl
test-kuttl: $(KUTTL) ## Run kuttl tests
	@echo Running kuttl tests... >&2
	@$(KUTTL) test --config kuttl-test.yaml

## Create kind cluster
.PHONY: kind-create-cluster
kind-create-cluster: $(KIND) 
	@echo Create kind cluster... >&2
	@$(KIND) create cluster --name $(KIND_NAME) 

## Delete kind cluster
.PHONY: kind-delete-cluster
kind-delete-cluster: $(KIND) 
	@echo Delete kind cluster... >&2
	@$(KIND) delete cluster --name $(KIND_NAME)

## Deploy Enterprise Kyverno
.PHONY: kind-deploy-kyverno
kind-deploy-kyverno: $(HELM) 
	@echo Install kyverno chart... >&2
	@echo $(N4K_LICENSE_KEY) >&2
	@$(HELM) repo add nirmata https://nirmata.github.io/kyverno-charts
	@$(HELM) install kyverno --namespace kyverno --create-namespace nirmata/kyverno --set licenseManager.licenseKey=$(N4K_LICENSE_KEY)

## Check Kyverno status 
.PHONY: wait-for-kyverno
wait-for-kyverno: 
	@echo Check kyverno status to be ready... >&2
	@kubectl wait --namespace kyverno --for=condition=ready pod --all --timeout=120s

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
