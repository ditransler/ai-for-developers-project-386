.DEFAULT_GOAL := help

.PHONY: help tsp-compile tsp-openapi prism-mock frontend-install frontend-dev frontend-build

help:
	@echo "Available targets:"
	@echo "  make tsp-compile       - TypeSpec compile (api-contract/)"
	@echo "  make tsp-openapi       - emit OpenAPI to api-contract/openapi.yaml"
	@echo "  make prism-mock        - Prism mock HTTP server (port 4010) from api-contract/openapi.yaml"
	@echo "  make frontend-install  - npm ci in frontend/"
	@echo "  make frontend-dev      - Nuxt dev server (long-running); often pair with make prism-mock"
	@echo "  make frontend-build    - Nuxt production build"

tsp-compile:
	npm --prefix api-contract run tsp:compile

tsp-openapi:
	npm --prefix api-contract run tsp:openapi

prism-mock:
	npx --yes @stoplight/prism-cli mock api-contract/openapi.yaml -p 4010

frontend-install:
	npm --prefix frontend ci

frontend-dev:
	npm --prefix frontend run dev

frontend-build:
	npm --prefix frontend run build
