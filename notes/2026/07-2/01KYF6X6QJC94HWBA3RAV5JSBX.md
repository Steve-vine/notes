---
id: 01KYF6X6QJC94HWBA3RAV5JSBX
created: 2026-07-26T12:37:56.594886Z
updated: 2026-07-26T12:37:56.594886Z
type: task
title: Fold api-types into the backend job (drop duplicate install)
task_status: backlog
priority: low
assignee: steve
label: tech_debt
project: 01KX671DATY39VW6GWK3M2T3DN
number: 320
---
The `api-types` job re-installs **uv AND node** just to regenerate `openapi.json` + `schema.d.ts` and diff them — duplicating the backend job's ~193s uv install and pulling node too (this job was seen taking 1–11m under contention). Fold the OpenAPI dump into the backend job (reuse its venv) and run the type-gen + drift check there or in the frontend job, removing one full uv install per run.

Acceptance: one fewer uv install per pipeline; the stale-types drift check still fails a PR that forgot `generate:api`.