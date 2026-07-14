---
id: 01KXGR7747Z58VQYFSEEJQ2RF1
created: 2026-07-14T16:44:03.079907258Z
updated: 2026-07-14T16:44:09.319753853Z
type: task
title: Backend API scaffolding (FastAPI)
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 5
sprint: s7hkfxa
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