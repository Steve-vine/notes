---
id: 01KX6DK8PX9SQRVRFX2JAF86N8
created: 2026-07-10T16:25:59.261801936Z
updated: 2026-07-10T16:38:32.089431663Z
type: task
title: Backend scaffold — uv, FastAPI, Ruff, mypy strict, pytest harness
task_status: active
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 1
sprint: sh9ng2k
---
Scaffold `app/backend/` (package `ISE_api`) per ADR 0003/0004: uv-managed Python 3.12, FastAPI skeleton, Ruff lint+format, mypy strict, pytest with testcontainers harness (real Postgres, no mocks/sqlite — ADR 0016).