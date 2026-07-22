---
id: 01KXWTM37WBJ1KBP8HNPW4GJNB
created: 2026-07-19T09:16:55.420572118Z
updated: 2026-07-22T11:45:42.34736Z
type: task
title: Typed directed edges + recursive traversal
project: 01KX671DATY39VW6GWK3M2T3DN
number: 126
sprint: sp5m61e
blocked_by:
- 01KXWTKZTHER145ZR0ARR81TMM
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 12 (spine).** The relationships that make it a graph.

- `entity_edge` — source → target, **edge_type** (`runs-on` / `depends-on` / `hosted-on` / `routes-to` / `part-of`), provenance, `last_confirmed`.
- **Recursive-CTE traversal** — from an entity walk to what it runs-on / depends-on / is-depended-on-by (blast radius). Postgres recursion, **not a graph DB** (ADR 0002).
- Alembic migration + read/traversal API. Integration tests (cycle-safe, bounded depth).

Depends on the entity/alias model.