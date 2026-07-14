---
id: 01KXGRS9EBHPWJH0ER229RRX4B
created: 2026-07-14T16:53:55.275809296Z
updated: 2026-07-14T16:54:07.771977045Z
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
comments:
- id: 01KXGRSNMVJ4R9QTXNDQA68C8B
  author: Steve Vine
  at: 2026-07-14T16:54:07.771877623Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 19:00 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/23

    All checklist items delivered:
    - **`core/celery_app.py`** — the `app` instance, configured from `Settings` (broker/result backend, `broker_pool_limit`/`worker_concurrency`/`task_default_queue`, JSON-only, UTC) + a beat heartbeat schedule.
    - **Worker/beat commands confirmed** — `-A compass_api.core.celery_app` resolves the `app` attribute; templates unchanged. Flipped `worker.enabled`/`beat.enabled` back to **true** (reversing DEV-429), per the agreed decision.
    - **Broker readiness check** on `/readyz`, registered when `BROKER_URL` is set and `READYZ_BROKER_CHECK_ENABLED`; tolerates transient blips (not-ready only after `READYZ_BROKER_CHECK_CONSECUTIVE_FAILURES` consecutive failures).
    - **Task conventions** — `tasks/health.py` `heartbeat()` is idempotent, no args, JSON result.
    - **Round-trip test** vs a real Valkey (testcontainers): enqueue → `start_worker` → result; plus the readiness consecutive-failure logic.

    Added `celery[redis]` (uv.lock updated). Verification: backend ruff/mypy(src) clean, 27 unit + 50 integration pass; `helm lint` clean and the default render now includes worker + beat.

    Left at In Review. On merge + redeploy, worker/beat come up Running/Ready (closing the DEV-429 crashloop for good) and `/readyz` gains a `broker` check — say the word and I'll merge, then roll the cluster.
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