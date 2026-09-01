---
id: 01M0E0YHDQEF56K51BVVG79MEK
created: 2026-08-19T22:05:58.071458Z
updated: 2026-09-01T13:55:50.613013Z
type: task
title: Directory graph backend — traversal endpoint over the mirror
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 303
order: 2.5
sprint: sar11t4
blocked_by:
- 01M0E0Y94T0VVD9MABB9VDQ7NF
comments:
- id: 01M0F5V4KHDTTBRFNSV672BGC2
  author: Steve Vine
  at: 2026-08-20T08:50:43.953675Z
  text: |-
    Done — PR #296 merged to main (squash 9303237), full CI suite green.

    `core/directory_graph.py` carries the shared expansion helper first: `nested_group_closure` (batched BFS over the direct group→group edges, cycle-guarded even though Entra forbids cycles, depth-bounded, vanished groups skipped) and `effective_members` returning direct / inherited / nested-group sets kept apart — the signature COM-300's fix consumes. `traverse_directory` does the bounded BFS (depth ≤ 6, node ceiling 400 with an explicit `truncated` flag, deterministic truncation via sorted candidate order) and `edges_within` fetches every real mirror edge among on-canvas nodes after the node set is known — the ADR 0048 §2 spanning-tree-plus-edges shape.

    `GET /api/v1/directory/graph?root=&direction=up|down|both&depth=N[&company=]` is read-gated `require_access_read`; the company param adds the business-role overlay (grants edges + role nodes for on-canvas groups, active non-deleted roles only) without widening the walk. Pydantic schemas in api/v1/schemas.py; schema.d.ts regenerated via scripts/ci/check-openapi-drift.sh.

    11 integration tests against real Postgres: nested chains, both directions from a user and a group, ownership edges, the cycle guard, depth/ceiling bounds, vanished exclusion, overlay on/off, unknown/vanished root 404s, and the read gate.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
`GET /api/v1/directory/graph?root=<object_id>&direction=up|down|both&depth=N` — BFS over the mirror tables (`directory_users`, `directory_groups`, `directory_group_members`, `directory_group_nested_members`, `directory_group_owners`), no live Graph calls.

* **The shared expansion helper first** (e.g. `core/directory_graph.py`): recursive walk over direct member + nested-group edges, deduplicated per person, **cycle-guarded** (Entra prevents membership cycles, but the walk must not trust that) and depth-bounded. This is the helper COM-300's fix consumes — design its signature for both callers (graph traversal *and* "effective members of group G").
* **Response shape mirrors ISE** (per ADR 0048): `root` ref; `nodes` = `[{id, name, kind: user|group|role, depth, via_edge_type}]` from the spanning-tree walk; `edges` = `[{source_id, target_id, edge_type}]` — every mirror edge whose both endpoints are on the canvas, fetched after the node set is known. `member_of` + `owner_of` edge types.
* **Role overlay**: optional `company=<uuid>` adds `grants` edges + business-role nodes from active `BusinessRoleGroup` mappings for groups already on the canvas — the one company-scoped element on a global read.
* **Bounds**: server-side depth cap (e.g. 6) and a node-count ceiling with a truncation flag; ring-capping/"+N more" stays client-side (ISE pattern). Exclude `vanished_at` rows by default.
* Read-gated `require_access_read`; Pydantic schemas in `api/v1/schemas.py`; regenerate `schema.d.ts`.
* **Integration tests (real Postgres)**: nested chains (user → A → B), both directions from a user and from a group, ownership edges, the cycle guard, depth/count bounds, vanished exclusion, overlay on/off.

Refs: ADR 0048, 0045 §3; `models/directory_mirror.py`, `models/business_role.py`, `api/v1/directory.py`; ISE `api/v1/entities.py` (`EntityGraph`) + `estate.py` (`edges_within`).