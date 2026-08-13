---
id: 01KZVAQBPZQP5HYEQ0HYCPZKRC
created: 2026-08-12T15:51:14.39981Z
updated: 2026-08-13T19:00:23.236996Z
type: task
title: 'Local development loop: iterate against the real estate in seconds'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 669
assignee: steve
label: improvement
priority: medium
task_status: backlog
tech: null
---
Make the edit→see-it loop seconds instead of minutes, so a feature can be shaped by iteration rather than batched into a waterfall. The CI/deploy path stays exactly as it is — it becomes the gate at the end of a feature, paid once, not once per turn.

**What runs where**
| | where | why |
|---|---|---|
| Postgres | staging, port-forwarded (`kubectl port-forward -n ise svc/ise-postgres-rw 5433:5432`) | the real ~7.4k-entity estate; every ISE screen is a view over it, so an empty local DB shows nothing worth judging |
| Redis + MinIO | local (`docker compose up -d redis minio`) | **critical**: sharing staging's valkey means your local worker and staging's compete for the same queued tasks, so "did my code run?" becomes a coin flip |
| API + worker | host, via uv, auto-reloading | no container rebuild in the loop; debugger-attachable |
| Frontend | host, `npm run dev` (Vite HMR → localhost:5173) | already proxies `/api` to :8000 |

**Deliverables**
- A start script doing the five steps (compose redis+minio, port-forward, uvicorn `--reload`, celery under a file-watcher, vite).
- `snapshot` / `restore` commands — `pg_dump` of staging into the local compose Postgres. NOT a maintained parallel database: a restore point before a deliberately destructive ingestion run, and the working DB whenever a feature changes schema.
- A `CLAUDE.md` section fixing the rules below.

**Hard rule — never run migrations from the local stack against the staging DB.** Staging's pods run the previous image; moving the schema under them breaks the live app while beat and the workers keep writing. And the data migrations transform real rows (0128 renames a layer, 0129 splits predicates, 0130 collapses identities) — a half-finished one against 7.4k entities is a re-sync of 22 systems, not a shrug. Schema work happens against a local snapshot; migrations are proven by the CI migration tests.

**Known gap:** the Kubernetes connector authenticates with the in-cluster ServiceAccount (`ise-integration/ise`), which a host process cannot fake. Every other connector works. K8s connector work needs staging, or a mirrord spike (evaluate separately — mirrord also removes the need to hold the master key on the host, by borrowing the pod's env at runtime).

**Credentials:** decided 2026-08-12 — the box is single-user and hosts staging anyway, so the real `ISE_CREDENTIAL_MASTER_KEY` may be reused locally. Without it, stored credentials never decrypt and no connector ingests.

Deferred 2026-08-12: Steve is trying the faster CI first to see how much of the pain it removes.