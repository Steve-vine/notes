---
id: 01KXGR7747Z58VQYFSEEJQ2RF1
created: 2026-07-14T16:44:03.079907258Z
updated: 2026-07-19T21:30:28.401247735Z
type: task
title: Backend API scaffolding (FastAPI)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 5
sprint: s7hkfxa
comments:
- id: 01KXGR7P35VE0H7MSB428K5HBM
  author: Steve Vine
  at: 2026-07-14T16:44:18.405824751Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 09:55 UTC]
    **Done building — moving to In Review.** PR: https://github.com/Steve-vine/compass/pull/4 (all 5 CI checks green)

    ## What was done
    - **`core/config.py`** — `pydantic-settings` `Settings` mirroring the chart's ConfigMap/Secret env-var contract exactly. Secrets/integrations (`database_url`, `session_secret_key`, …) default to `None` so the app boots locally with no env.
    - **`core/logging.py`** — structured JSON logging to stdout + a redaction list (values under sensitive keys passed via `extra=` are masked, incl. nested).
    - **`core/errors.py`** — one envelope `{"error": {"type","message","detail"}}` + handlers (`APIError`, `HTTPException`, validation 422, unhandled 500 logged without leaking).
    - **`core/health.py`** — `/healthz` (liveness) + `/readyz` (readiness **check registry**; 503 if any fail).
    - **`api/v1/router.py`** — `/api/v1` router + `GET /api/v1/meta`.
    - **`main.py`** — `create_app()` wiring logging, handlers, routers, Prometheus `/metrics`.
    - Deps: fastapi, uvicorn[standard], pydantic-settings, prometheus-fastapi-instrumentator. 18 tests, 98% coverage; smoke-run via uvicorn confirmed every endpoint.

    ## Decisions on the fly
    - **JSON logging via stdlib + a custom formatter** (no extra dependency) rather than structlog — keeps deps minimal and gives full control over redaction.
    - **Seeded `GET /api/v1/meta`** so OpenAPI generation and routing are real/testable rather than shipping an empty router.

    ## Deferred by dependency (as planned)
    - **`/readyz` DB check** — the acceptance line "incl. DB check" is intentionally a *framework* for now: `/readyz` runs a check registry but no checks are registered yet. DEV-392 registers the DB ping. This is the one criterion not fully closed here, by design.
    - **Celery `compass_api.core.celery_app`** (referenced by the worker/beat Deployments) — no Celery issue exists in M1; those pods remain non-functional until Celery is wired. Flagging in case you want a `follow-up` issue to track it.
    - Auth cookie behaviour — fields declared, consumed by DEV-393.

    ## Acceptance criteria
    - [x] FastAPI app with `/api/v1` router and generated OpenAPI
    - [x] `pydantic-settings` env-driven config (12-factor)
    - [x] `/healthz` + `/readyz` — **DB check deferred to DEV-392** (registry in place)
    - [x] Structured JSON logging to stdout + redaction list
    - [x] Prometheus metrics endpoint
    - [x] Error handling + consistent API error shape
- id: 01KXGR7X05X8CCC1AA08N5H0WG
  author: Steve Vine
  at: 2026-07-14T16:44:25.477538887Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 09:59 UTC]
    **Merged + verified — Done.** Squash-merged as `9057438` ([PR #4](https://github.com/Steve-vine/compass/pull/4)); post-merge `release.yml` rebuilt and pushed the backend/frontend images to GHCR with the real dependencies (build green).

    Celery gap tracked as follow-up **DEV-416** (parent-linked here). Next: **DEV-392** (DB foundation), which registers the deferred `/readyz` DB check into the registry built here.
assignee: steve
task_status: done
priority: medium
---
Stand up the FastAPI application skeleton per ADR 0002/0004/0008.

- [ ] FastAPI app with `/api/v1` router and generated OpenAPI
- [ ] `pydantic-settings` env-driven config (12-factor)
- [ ] `/healthz` (liveness) and `/readyz` (readiness, incl. DB check)
- [ ] Structured JSON logging to stdout + log-redaction list
- [ ] Prometheus metrics endpoint
- [ ] Error handling + consistent API error shape

Depends on: Monorepo scaffolding. Refs: ADR 0002, 0004, 0008.

---
*Migrated from Linear [DEV-391](https://linear.app/stevevine/issue/DEV-391/backend-api-scaffolding-fastapi) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-392, DEV-393*