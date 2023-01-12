.DEFAULT_GOAL: build-all

############
# DEFAULTS #
############

K8S_VERSION          ?= $(shell kubectl version --short | grep -i server | cut -d" " -f3 | cut -c2-)
KIND_IMAGE           ?= kindest/node:v1.25.3
KIND_NAME            ?= kind
USE_CONFIG           ?= standard

#########
# TOOLS #
#########

TOOLS_DIR                          := $(PWD)/.tools
KIND                               := $(TOOLS_DIR)/kind
KIND_VERSION                       := v1.25.3
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
install-tools: $(TOOLS) ## Install tools

.PHONY: clean-tools
clean-tools: ## Remove installed tools
	@echo Clean tools... >&2
	@rm -rf $(TOOLS_DIR)

###############
# KUTTL TESTS #
###############

.PHONY: test-kuttl
test-kuttl: $(KUTTL) ## Run kuttl tests
	@echo Running kuttl tests... >&2
	@$(KUTTL) test --config ./tests/kuttl-test/kuttl-test.yaml

########
# KIND #
########

.PHONY: kind-create-cluster
kind-create-cluster: $(KIND) ## Create kind cluster
	@echo Create kind cluster... >&2
	@$(KIND) create cluster --name $(KIND_NAME) --image $(KIND_IMAGE) 

.PHONY: kind-delete-cluster
kind-delete-cluster: $(KIND) ## Delete kind cluster
	@echo Delete kind cluster... >&2
	@$(KIND) delete cluster --name $(KIND_NAME)

.PHONY: kind-deploy-kyverno-operator
kind-deploy-kyverno: $(HELM) repo add nirmata https://nirmata.github.io/kyverno-charts  
	@echo Install kyverno chart... >&2
	@$(HELM) install kyverno-operator --namespace nirmata-kyverno-operator --create-namespace nirmata/kyverno-operator --set imagePullSecret.create=false

.PHONY: kind-deploy-kyverno
kind-deploy-kyverno: $(HELM) repo add nirmata https://nirmata.github.io/kyverno-charts  
	@echo Install kyverno chart... >&2
	@$(HELM) install kyverno --namespace nirmata-kyverno --create-namespace nirmata/kyverno --set image.pullSecrets.create=false

.PHONY: kind-deploy-kyverno-policies
kind-deploy-kyverno-policies: 
	@echo Install kyverno-policies ... >&2
	@kubectl apply -k ./best-practices/

.PHONY: kind-deploy-all
kind-deploy-all: | kind-deploy-kyverno-operator kind-deploy-kyverno kind-deploy-kyverno-policies
