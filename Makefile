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

.PHONY: kind-deploy-kyverno-operator
kind-deploy-kyverno-operator: $(HELM)
	@echo Install kyverno chart... >&2
	@$(HELM) repo add nirmata https://nirmata.github.io/kyverno-charts 
	@$(HELM) install kyverno-operator --namespace nirmata-kyverno-operator --create-namespace nirmata/kyverno-operator --set imagePullSecret.create=false

.PHONY: kind-deploy-kyverno
kind-deploy-kyverno: $(HELM) 
	@echo Install kyverno chart... >&2
	@$(HELM) repo add nirmata https://nirmata.github.io/kyverno-charts
	@$(HELM) install kyverno --namespace kyverno --create-namespace nirmata/kyverno --set licenseManager.licenseKey=c2yPkGGVtnbubN8EozSDq8ioQQ7wSffSf6DLV+mv2A794EHC3aHrGmRlZe4MBoC0FHw4x17Wyewgezjy+ldmpLzlxusJFEUqL6dPpJbClVPPWevJGWWJBIaOtCFCbiQfxHxmAPMfY8h+Xuwd629OAK1AzOdzdIljWIIYFPwyysnJTvuP3tw6dFtUCA1Cd34/iTanxjqvHPk/7WGwc67vkv0CWRJANdzT+xRSid9g1mqjrY8OIgp0HsQzIiHpDUKk7aA4QpUQxhkS5Jx5ckuPwpnUtKNed93M7g+Rz9aHJ1g=

.PHONY: kind-deploy-all
kind-deploy-all: | kind-deploy-kyverno-operator kind-deploy-kyverno kind-deploy-kyverno-policies
