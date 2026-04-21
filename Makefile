.DEFAULT_GOAL := help

.PHONY: help tsp-compile tsp-openapi prism-mock frontend-install frontend-dev frontend-build \
	backend-restore backend-build backend-run backend-watch backend-test backend-format backend-format-check

help:
	@echo "Available targets:"
	@echo "  make tsp-compile       - TypeSpec compile (api-contract/)"
	@echo "  make tsp-openapi       - emit OpenAPI to api-contract/openapi.yaml"
	@echo "  make prism-mock        - Prism mock HTTP server (port 4010) from api-contract/openapi.yaml"
	@echo "  make frontend-install  - npm ci in frontend/"
	@echo "  make frontend-dev      - Nuxt dev server (long-running); often pair with make prism-mock"
	@echo "  make frontend-build    - Nuxt production build"
	@echo "  make backend-restore  - dotnet restore (backend/CalendarBooking.slnx)"
	@echo "  make backend-build    - dotnet build (backend/CalendarBooking.slnx)"
	@echo "  make backend-run      - dotnet run the API (default port from launchSettings, 5005)"
	@echo "  make backend-watch     - dotnet watch run the API"
	@echo "  make backend-test      - dotnet test (backend/CalendarBooking.slnx)"
	@echo "  make backend-format    - dotnet format (write)"
	@echo "  make backend-format-check - dotnet format --verify-no-changes (CI)"

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

BACKEND_SLN := backend/CalendarBooking.slnx
BACKEND_PROJ := backend/src/CalendarBooking.Api/CalendarBooking.Api.csproj

backend-restore:
	dotnet restore $(BACKEND_SLN)

backend-build: backend-restore
	dotnet build $(BACKEND_SLN) --no-restore

backend-run: backend-restore
	dotnet run --project $(BACKEND_PROJ) --no-restore

backend-watch: backend-restore
	dotnet watch run --project $(BACKEND_PROJ) --no-restore

backend-test: backend-restore
	dotnet test $(BACKEND_SLN) --no-restore

backend-format: backend-restore
	dotnet format $(BACKEND_SLN) --no-restore

backend-format-check: backend-restore
	dotnet format $(BACKEND_SLN) --no-restore --verify-no-changes
