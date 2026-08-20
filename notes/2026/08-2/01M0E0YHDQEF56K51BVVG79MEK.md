---
id: 01M0E0YHDQEF56K51BVVG79MEK
created: 2026-08-19T22:05:58.071458Z
updated: 2026-08-20T08:21:22.185518Z
type: task
title: Directory graph backend — traversal endpoint over the mirror
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 303
order: 2.5
sprint: sar11t4
blocked_by:
- 01M0E0Y94T0VVD9MABB9VDQ7NF
assignee: steve
label:
- feature
priority: medium
task_status: active
---
`GET /api/v1/directory/graph?root=<object_id>&direction=up|down|both&depth=N` — BFS over the mirror tables (`directory_users`, `directory_groups`, `directory_group_members`, `directory_group_nested_members`, `directory_group_owners`), no live Graph calls.

* **The shared expansion helper first** (e.g. `core/directory_graph.py`): recursive walk over direct member + nested-group edges, deduplicated per person, **cycle-guarded** (Entra prevents membership cycles, but the walk must not trust that) and depth-bounded. This is the helper COM-300's fix consumes — design its signature for both callers (graph traversal *and* "effective members of group G").
* **Response shape mirrors ISE** (per ADR 0048): `root` ref; `nodes` = `[{id, name, kind: user|group|role, depth, via_edge_type}]` from the spanning-tree walk; `edges` = `[{source_id, target_id, edge_type}]` — every mirror edge whose both endpoints are on the canvas, fetched after the node set is known. `member_of` + `owner_of` edge types.
* **Role overlay**: optional `company=<uuid>` adds `grants` edges + business-role nodes from active `BusinessRoleGroup` mappings for groups already on the canvas — the one company-scoped element on a global read.
* **Bounds**: server-side depth cap (e.g. 6) and a node-count ceiling with a truncation flag; ring-capping/"+N more" stays client-side (ISE pattern). Exclude `vanished_at` rows by default.
* Read-gated `require_access_read`; Pydantic schemas in `api/v1/schemas.py`; regenerate `schema.d.ts`.
* **Integration tests (real Postgres)**: nested chains (user → A → B), both directions from a user and from a group, ownership edges, the cycle guard, depth/count bounds, vanished exclusion, overlay on/off.

Refs: ADR 0048, 0045 §3; `models/directory_mirror.py`, `models/business_role.py`, `api/v1/directory.py`; ISE `api/v1/entities.py` (`EntityGraph`) + `estate.py` (`edges_within`).