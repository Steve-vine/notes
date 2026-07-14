---
id: 01KXGRS9EBHPWJH0ER229RRX4B
created: 2026-07-14T16:53:55.275809296Z
updated: 2026-07-14T16:54:02.227258731Z
type: task
title: Wire Celery app + broker (worker/beat + readyz broker check)
task_status: done
label:
- follow_up
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 22
sprint: sz3kacg
---
Surfaced during <issue id="69cbe30d-04be-4aff-a0e7-138a914ecc70" href="https://linear.app/stevevine/issue/DEV-391/backend-api-scaffolding-fastapi">DEV-391</issue>. The Helm chart's **worker** and **beat** Deployments (<issue id="f0a2a763-d31f-4369-8332-10ba499ec5a7" href="https://linear.app/stevevine/issue/DEV-396/deployment-and-observability-skeleton-helm">DEV-396</issue>) run `celery -A compass_api.core.celery_app …`, but that module doesn't exist — there is no Celery issue anywhere in M1, so those pods are non-functional. ADR 0006 mandates Celery + Redis/Valkey for background tasks.

Wire the Celery spine so the deployment skeleton actually works end to end:

- [ ] `compass_api/core/celery_app.py` — Celery app reading `BROKER_URL` / `RESULT_BACKEND_URL` + tuning (`BROKER_POOL_LIMIT`, `WORKER_CONCURRENCY`, `TASK_DEFAULT_QUEUE`) from `Settings`.
- [ ] Confirm worker/beat container commands match the entrypoint the chart expects.
- [ ] Register a **broker readiness check** into `core/health.py`'s registry, honouring `READYZ_BROKER_CHECK_ENABLED` / `READYZ_BROKER_CHECK_CONSECUTIVE_FAILURES` (config already present).
- [ ] Task conventions per CLAUDE.md (idempotent, take IDs not objects, JSON serialization).
- [ ] A trivial example/health task + test to prove the broker round-trips (integration test against a real Valkey).

Depends on: <issue id="69cbe30d-04be-4aff-a0e7-138a914ecc70" href="https://linear.app/stevevine/issue/DEV-391/backend-api-scaffolding-fastapi">DEV-391</issue> (API scaffolding). Refs: ADR 0006, 0008. Parent: <issue id="69cbe30d-04be-4aff-a0e7-138a914ecc70" href="https://linear.app/stevevine/issue/DEV-391/backend-api-scaffolding-fastapi">DEV-391</issue>.

Note: needs confirming whether background tasks belong in M1 (walking skeleton) or can slip to M2 — milestone set to M1 provisionally since the worker/beat pods already ship in the chart.

---
*Migrated from Linear [DEV-416](https://linear.app/stevevine/issue/DEV-416/wire-celery-app-broker-workerbeat-readyz-broker-check) · created 2026-06-14 · completed 2026-06-16*  
*Related to (Linear): DEV-429, DEV-396, DEV-460, DEV-420, DEV-395, DEV-417, DEV-393*