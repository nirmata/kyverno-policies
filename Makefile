
###########
# CODEGEN #
###########

.PHONY: codegen-helm-docs
codegen-helm-docs: ## Generate helm docs
	@echo Generate helm docs... >&2
	@docker run -v ${PWD}:/work -w /work jnorwood/helm-docs:v1.11.0 -s file

.PHONY: verify-helm-docs
verify-helm-docs: codegen-helm-docs ## Check helm docs are up to date
	@echo Checking helm docs are up to date... >&2
	@git --no-pager diff ${PWD}
	@git diff --quiet --exit-code ${PWD}