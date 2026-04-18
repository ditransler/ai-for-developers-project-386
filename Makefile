.DEFAULT_GOAL := help

.PHONY: help tsp-compile tsp-openapi

help:
	@echo "Available targets:"
	@echo "  make tsp-compile   - run npm run tsp:compile"
	@echo "  make tsp-openapi   - run npm run tsp:openapi"

tsp-compile:
	npm run tsp:compile

tsp-openapi:
	npm run tsp:openapi
