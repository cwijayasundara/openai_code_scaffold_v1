# ============================================================
# Project Makefile — build, lint, test, deploy targets
# ============================================================

.PHONY: help build lint format lint-custom test test-unit test-integration ci validate

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ---- Build ----

build: ## Install dependencies
	pip install -e ".[dev]"

# ---- Lint & Type Check ----

lint: ## Run ruff + mypy
	ruff check src/ tests/
	ruff format --check src/ tests/
	mypy src/

format: ## Auto-fix lint issues
	ruff check --fix src/ tests/
	ruff format src/ tests/

lint-custom: ## Run 5 custom linters
	bash scripts/lint_all.sh

# ---- Tests ----

test-unit: ## Run unit tests (80% coverage minimum)
	pytest tests/ -m unit --cov=src --cov-report=term-missing --cov-fail-under=80

test-integration: ## Run integration tests
	pytest tests/ -m integration

test: test-unit test-integration ## Run unit + integration

# ---- CI ----

ci: lint lint-custom test ## Full CI: lint + custom linters + tests

# ---- Validate ----

validate: ## Run all custom linters
	bash scripts/lint_all.sh
