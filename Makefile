.DEFAULT_GOAL := help

.PHONY: help tsp-compile tsp-openapi

help:
	@echo "Available targets:"
	@echo "  make tsp-compile   - TypeSpec compile (api-contract/)"
	@echo "  make tsp-openapi   - emit OpenAPI to api-contract/openapi.yaml"

tsp-compile:
	npm --prefix api-contract run tsp:compile

tsp-openapi:
	npm --prefix api-contract run tsp:openapi
