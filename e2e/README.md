# End-to-end tests (Playwright)

TypeScript tests under [`tests/`](tests/) use the real [.NET API](../backend/src/CalendarBooking.Api/) and a **Nuxt dev server** from [`frontend/`](../frontend/) (see [scripts/run-e2e.sh](scripts/run-e2e.sh); production `nuxt build` + `node .output/server/index.mjs` currently fails SSR in this project with a Vue bundling error, while `nuxi dev` matches normal local development and works with the same API base URL).

- **Scenarios** — [SCENARIOS.md](SCENARIOS.md)
- **Run everything (from repo root):** `make e2e` — starts the API, seeds an event type, runs Nuxt in dev mode, then runs Playwright
- **Lint / format / typecheck only (no browser):** `make e2e-verify` or `cd e2e && npm run verify`
- **Environment:** `E2E_BASE_URL` (default `http://127.0.0.1:3123`, see `e2e/scripts/run-e2e.sh`) is set by the Makefile runner; the frontend must be built with `NUXT_PUBLIC_API_BASE_URL` pointing at the same API the tests use (the runner sets this for `make e2e`). Override with `E2E_FRONTEND_PORT` / `E2E_BASE_URL` if needed.

To debug with servers already up and the same env as `make e2e`, run from `e2e/`: `npm test`.
