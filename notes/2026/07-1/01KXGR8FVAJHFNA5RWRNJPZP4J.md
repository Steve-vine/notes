---
id: 01KXGR8FVAJHFNA5RWRNJPZP4J
created: 2026-07-14T16:44:44.778373218Z
updated: 2026-07-14T16:44:44.778373218Z
type: task
title: Database foundation (SQLAlchemy + Alembic)
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 6
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