---
id: 01KXGXMBDZFB2Y0F35250K2QKQ
created: 2026-07-14T18:18:36.351172992Z
updated: 2026-07-14T18:18:43.195506572Z
type: task
title: Share a session-scoped Postgres across integration test modules
label:
- tech_debt
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 163
sprint: sc5mwga
---
31 test modules each start their own `PostgresContainer` (module-scoped fixtures), so a full integration run pays 31× container start + initdb + Alembic migrations — the dominant cost of the backend CI job (measured <issue id="3de7fec8-9bd5-4ed2-a1c6-d4304c5e370a" href="https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server">DEV-845</issue>).

Refactor to one session-scoped Postgres container with a per-module database (`CREATE DATABASE` + run migrations once into a template DB, then `CREATE DATABASE ... TEMPLATE template_compass` per module — near-instant). Biggest single speedup available (~31× startup cost → 1×), but the largest refactor of the four CI-performance issues; do after <issue id="66449ff6-c992-4db6-beb4-17fbdb4bd6ef" href="https://linear.app/stevevine/issue/DEV-852/run-integration-test-postgres-with-durability-off-fsync-synchronous">DEV-852</issue>/<issue id="5641278a-12d6-49fc-8989-1400106b4b2a" href="https://linear.app/stevevine/issue/DEV-853/parallelise-backend-integration-tests-with-pytest-xdist">DEV-853</issue> land, and keep compatibility with pytest-xdist workers (e.g. one container per worker or a lock around database creation).

---
*Migrated from Linear [DEV-855](https://linear.app/stevevine/issue/DEV-855/share-a-session-scoped-postgres-across-integration-test-modules) · created 2026-07-05 · completed 2026-07-06*  
*Related to (Linear): DEV-853, DEV-852, DEV-845, DEV-854*