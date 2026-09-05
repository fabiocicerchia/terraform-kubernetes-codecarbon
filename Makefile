# Every verb this repository exposes lives here; `make` on its own prints them.
# FC-GEN-057: the same eight verbs in every repo, each either wired, a declared
# no-op that says why, or absent and failing loudly. None of them exit 0 quietly.

.DEFAULT_GOAL := help

.PHONY: help setup build install test lint run format analyze

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

setup: ## Install the pre-commit hook
	pre-commit install

install: ## Download the providers this module pins
	terraform init -backend=false

lint: ## Run the whole gate — every hook, every file
	pre-commit run --all-files

format: ## Rewrite the Terraform sources to canonical form
	terraform fmt -recursive

test: ## Validate the module and its examples
	terraform init -backend=false >/dev/null
	terraform validate
	cd examples && terraform init -backend=false >/dev/null && terraform validate

analyze: ## Lint the Terraform for correctness and style
	@command -v tflint >/dev/null 2>&1 || { \
		echo "analyze needs tflint: https://github.com/terraform-linters/tflint" >&2; \
		exit 69; }
	tflint --recursive

# --- Declared no-ops (FC-GEN-058) ---
# These exit 0 and say why. They are listed under "Not applicable" in the README.

build: ## Not applicable — nothing is compiled
	@echo "Nothing to build: this is a Terraform module, consumed from source."
	@echo "See README > Not applicable."

run: ## Not applicable — a module is instantiated, not executed
	@echo "Nothing to run: a module is called by a root module, never run directly."
	@echo "See README > Not applicable."
