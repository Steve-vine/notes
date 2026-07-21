---
id: 01KX6DK8PX9SQRVRFX2JAF86N8
created: 2026-07-10T16:25:59.261801936Z
updated: 2026-07-21T09:54:09.192979Z
type: task
title: Backend scaffold — uv, FastAPI, Ruff, mypy strict, pytest harness
project: 01KX671DATY39VW6GWK3M2T3DN
number: 1
sprint: sh9ng2k
comments:
- id: 01KX6EESZJA12XRMT49RFXRY96
  author: Steve Vine
  at: 2026-07-10T16:41:01.682642442Z
  text: 'Development complete on feature/ise-001-backend-scaffold. PR #3 open against main: https://github.com/Steve-vine/ise/pull/3. Branch merged to staging (0935fad). Verified locally: Ruff clean, mypy strict clean, pytest 3/3 passed (incl. real Postgres 16 via testcontainers), uvicorn boots and serves /api/v1/meta. Awaiting Steve''s smoke test and merge clearance. Note: no CI exists yet (ISE-7), so PR checks are green-by-absence.'
- id: 01KX6HHJFSG093E4Z2D7DJD5C0
  author: Steve Vine
  at: 2026-07-10T17:34:58.041099008Z
  text: 'Smoke tests passed. PR #3 merged to main (45d7fd6), feature branch deleted. Done.'
assignee: steve
priority: high
task_status: done
---
Scaffold `app/backend/` (package `ISE_api`) per ADR 0003/0004: uv-managed Python 3.12, FastAPI skeleton, Ruff lint+format, mypy strict, pytest with testcontainers harness (real Postgres, no mocks/sqlite — ADR 0016).