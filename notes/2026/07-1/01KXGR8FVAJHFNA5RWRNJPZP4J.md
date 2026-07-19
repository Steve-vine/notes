---
id: 01KXGR8FVAJHFNA5RWRNJPZP4J
created: 2026-07-14T16:44:44.778373218Z
updated: 2026-07-19T21:30:30.275715274Z
type: task
title: Database foundation (SQLAlchemy + Alembic)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 6
sprint: s7hkfxa
comments:
- id: 01KXGR8YBDF58HKSD6MV39N16N
  author: Steve Vine
  at: 2026-07-14T16:44:59.629005811Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 10:15 UTC]
    **Done building — moving to In Review.** PR: https://github.com/Steve-vine/compass/pull/5 (all 5 CI checks green; the `backend` job now also runs the Postgres integration suite)

    ## What was done
    - **`db/base.py`** — `DeclarativeBase` + constraint naming convention.
    - **`db/mixins.py`** — `UUIDPrimaryKeyMixin`, `TimestampMixin`, `ActorMixin`, `SoftDeleteMixin` (ADR 0005 standards).
    - **`db/session.py`** — sync SQLAlchemy 2.0 engine (psycopg 3), sessionmaker, `get_session()` dependency, `database_ready()`.
    - **`main.py`** — registers the DB readiness check on `/readyz` when `DATABASE_URL` is set → **closes the `/readyz` DB check deferred by DEV-391**.
    - **Alembic** — `alembic.ini`, `migrations/env.py` (URL from `Settings`), empty baseline `0001`. **Dockerfile** copies `alembic.ini` + `migrations/` so the chart's migrate hook works.
    - **Local dev** — root `compose.yaml` (Postgres 16 + Valkey) + `app/backend/.env.example`; README + CLAUDE.md run notes.
    - Tests: integration vs real Postgres (testcontainers) — alembic up *and* down, mixins round-trip, `database_ready`; unit for the unconfigured path. CI `backend` job runs `pytest -m integration`.

    ## Decisions on the fly
    - **Foundation only** (per your call) — empty baseline migration; entity tables land with their own briefs.
    - **`created_by`/`updated_by` are nullable UUIDs with no FK yet** — the FK to `users` is added when DEV-393 creates that table (avoids a forward dependency).
    - **psycopg 3** driver (`postgresql+psycopg://`) to match the migrate hook's DSN handling.
    - CI integration tests run **inside the existing `backend` job** (no new required-status-check context; branch protection unchanged).

    ## Notes
    - `docker compose` plugin isn't installed on the dev box, so the compose path was validated via the testcontainers integration tests + a YAML lint rather than `docker compose up`. CI doesn't use compose (testcontainers talks to Docker directly).

    ## Acceptance criteria
    - [x] SQLAlchemy 2.0 (sync) engine/session wiring, connect via CNPG `-rw` (psycopg 3 DSN)
    - [x] Base model mixins (UUID PK, timestamps, actor, soft-delete)
    - [x] Alembic configured; first (baseline) migration
    - [x] Migrations run as the Helm pre-upgrade hook (Dockerfile now ships `alembic.ini` + `migrations/`)
    - [x] Test harness against a real ephemeral Postgres (testcontainers; runs up *and* down)
- id: 01KXGR98EYKRJFHTBWEE50WMW9
  author: Steve Vine
  at: 2026-07-14T16:45:09.982216304Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 10:18 UTC]
    **Merged + verified — Done.** Squash-merged as `82807d9` ([PR #5](https://github.com/Steve-vine/compass/pull/5)); post-merge `release.yml` rebuilt and pushed the backend image (now including `alembic.ini` + `migrations/`) — build green.

    Next: **DEV-393** (Auth), which also adds the `created_by`/`updated_by` FK to the `users` table noted here.
assignee: steve
task_status: done
priority: medium
---
Establish the persistence layer and migration discipline per ADR 0005.

- [ ] SQLAlchemy 2.0 (sync) engine/session wiring, connect via CNPG `-rw` service
- [ ] Base model mixins: UUID PK, `created_at`/`updated_at`, `created_by`/`updated_by`, soft-delete/status
- [ ] Alembic configured; first migration scaffold
- [ ] Migrations run as a Helm pre-upgrade hook Job (never at container start)
- [ ] Test harness against a real ephemeral Postgres (no mocks/sqlite)

Depends on: Backend API scaffolding. Refs: ADR 0005, 0015, 0016.

---
*Migrated from Linear [DEV-392](https://linear.app/stevevine/issue/DEV-392/database-foundation-sqlalchemy-alembic) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-393, DEV-391, DEV-390, DEV-389*