---
id: 01KXWTKZTHER145ZR0ARR81TMM
created: 2026-07-19T09:16:51.921163151Z
updated: 2026-07-19T13:25:15.75893662Z
type: task
title: Entity + integration alias model
assignee: steve
task_status: done
label:
- feature
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 125
blocked_by:
- 01KXWTKVXKPQCNV27X9Y3CHGXA
sprint: sp5m61e
---
**Sprint 12 (spine).** The structural backbone of the estate knowledge base.

- `entity` — canonical id, **type** (service / cluster / database / host / namespace / …), name.
- `entity_alias` — `entity_id`, the integration/`System` it came from, and the **native key** (`datadog:service:service-x`, `k8s:g5/team-a/deploy/service-x`).
- Distinct from `System` (a connected integration instance): estate entities live **across and inside** Systems.
- Alembic migration + read API. Integration tests.

The load-bearing spine (per Canon) — context, edges, memory, and conversational enrichment all hang off this. Depends on the Estate KB ADR.