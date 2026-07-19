---
id: 01KX6DKNCP0TJDRGXS8GHHYAKK
created: 2026-07-10T16:26:12.246881334Z
updated: 2026-07-19T13:25:11.320835783Z
type: task
title: Wire Postgres + SQLAlchemy + Alembic
project: 01KX671DATY39VW6GWK3M2T3DN
number: 4
sprint: sh9ng2k
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
comments:
- id: 01KX6MW23GZBB20A80R7CX7ZK3
  author: Steve Vine
  at: 2026-07-10T18:33:07.439739828Z
  text: 'Development complete on feature/ise-004-postgres-alembic. PR #6: https://github.com/Steve-vine/ise/pull/6. Sync SQLAlchemy 2.0 + Alembic wired per ADR 0002/0005: db.py (engine/session factories, Base with naming conventions), pydantic-settings (ISE_ prefix, .env.example), typed alembic env, empty baseline revision 0001. CI migration checks live: append-only step in backend job (closes the ISE-7 deferral) + integration tests migrating fresh Postgres zero→head with compare_metadata models-match, single-head, session round-trip. Migrations ship in the backend image for the ISE-8 Helm hook (verified: docker run … alembic heads → 0001). PR CI green on ise-runners; staging pipeline green, images staging-20260710-1831 + 0da0c92 in zot. Awaiting smoke test and merge clearance.'
- id: 01KX6N5TEPHMHP0ZC9Y93PDZ9S
  author: Steve Vine
  at: 2026-07-10T18:38:27.286559409Z
  text: 'Smoke tests passed. PR #6 merged to main (f89a8d0), branch deleted. Belt-and-braces main run green, main-tagged images pushed. Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Sync SQLAlchemy 2.0 sessions against Postgres (ADR 0002) with Alembic configured, an initial baseline migration, and the append-only migration check in place (ADR 0005).