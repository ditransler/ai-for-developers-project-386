.DEFAULT_GOAL := help

.PHONY: help tsp-compile tsp-openapi prism-mock

help:
	@echo "Available targets:"
	@echo "  make tsp-compile   - TypeSpec compile (api-contract/)"
	@echo "  make tsp-openapi   - emit OpenAPI to api-contract/openapi.yaml"
	@echo "  make prism-mock    - Prism mock HTTP server (port 4010) from api-contract/openapi.yaml"

tsp-compile:
	npm --prefix api-contract run tsp:compile

tsp-openapi:
	npm --prefix api-contract run tsp:openapi

prism-mock:
	npx --yes @stoplight/prism-cli mock api-contract/openapi.yaml -p 4010
