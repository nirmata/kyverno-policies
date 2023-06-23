.DEFAULT_GOAL: build-all

K8S_VERSION          ?= $(shell kubectl version --short | grep -i server | cut -d" " -f3 | cut -c2-)
KIND_IMAGE           ?= kindest/node:v1.27.1
KIND_NAME            ?= kind
USE_CONFIG           ?= standard

TOOLS_DIR                          := $(PWD)/.tools
KIND                               := $(TOOLS_DIR)/kind
KIND_VERSION                       := v0.19.0
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
	@$(HELM) install kyverno --namespace kyverno --create-namespace nirmata/kyverno --set licenseManager.licenseKey=+7BT76LNHCKLi3vW2mbYP5vYuS+Rm4XaLPu7k6Vgq4/efR3BEJk6Ru+zOFJagN2l0oLyG15qZ2kkXpzqaeEAal6APDLB7s3htLFeJ6mf0hc7/3dupUY13zrdX5svkS5p6BNKVisuXwK5XfF8sJyLn16I/CRdICj9fzktWQWYB5h46xOj5NlMPMj0/m6tCa3hIVJpB9Onkd4KMXlO+PQUbUwk/wxuciQkGwjbXQs+V9w0MuWMODpY0jGN1dgLNETI7mpS6G5DVvHkbAtrJ+gvG15aFFtKjgPInoemqxbhj2wzYue5pNSdHUZYE9b+LLlj --set image.tag=v1.10.0-n4k.nirmata.1 --set initImage.tag=v1.10.0-n4k.nirmata.1 --set cleanupController.image.tag=v1.10.0-n4k.nirmata.1

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
