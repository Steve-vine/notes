---
id: 01KZV5BPZ43WHZNT0D9KD4DGKS
created: 2026-08-12T14:17:29.828611Z
updated: 2026-08-12T14:17:29.828611Z
type: task
title: 'Backend suite: a live broker, and a cloned schema instead of 130 replayed migrations'
task_status: backlog
label: improvement
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 666
---
`pytest` is **617s of the 771s backend job**, and the backend job is the whole pipeline — every other job (changes 20s, secret-scan 20s, api-types 75s, backend-lint 127s, frontend 136s) finishes inside 2.5 min and they already run in parallel. Two structural faults, both measured on 2026-08-12.

**1. The Celery broker is dead in tests.** Test modules set `ISE_SESSION_REDIS_URL` to a container but leave `redis_url` — the broker — at its `localhost:6379` default, where nothing listens. Every `apply_async` on a request path then blocks in kombu's connection retry before the endpoint gives up and returns anyway. Measured `POST /proposed-changes/{id}/approve`: **19.04s → 0.04s** once the broker is live. ~30 tests sat in a 19.3–19.8s cluster from this, `test_an_approval_survives_a_dead_broker` among them — the broker was dead for all of them, so that test was not testing what it named.

Setting `ISE_REDIS_URL` in a fixture is **too late**: `ISE_api.worker` reads Settings and builds `app` at import time, and Celery caches its plumbing on first touch. The process-global app must be repointed with all three caches cleared (`_backend_cache`, `_local.backend`, `close()`, `del app.amqp`) — the same three `tests/integration/test_celery.py` already handles.

**2. Every module replays all 130 migrations.** `postgres_url` is module-scoped and each of ~160 modules runs `alembic upgrade head` into an empty database: measured ~2.8–6.2s each and **growing with every migration added**. Postgres can copy a finished database instead — `CREATE DATABASE ... TEMPLATE` measured at **0.19s** and flat in the migration count. Migrate once per xdist worker into a template, clone per module; the existing per-module `command.upgrade(..., "head")` calls stay put and become ~40ms no-ops.

**Trap:** cloning from a migrated template silently turns `test_migrate_zero_to_head_and_models_match` into a no-op — it must be repointed at a virgin database or that gate stops running while staying green. The other 26 data-path migration tests already build their own database via `_fresh_database` and are unaffected.

**Measured result:** 669s → 399s locally (**-40%**), 3403 passed, ruff + ruff format + mypy strict clean.

No user-facing surface — this is CI/infra work, stated explicitly per the definition of done.