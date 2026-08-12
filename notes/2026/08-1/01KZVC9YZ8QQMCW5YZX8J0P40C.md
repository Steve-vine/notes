---
id: 01KZVC9YZ8QQMCW5YZX8J0P40C
created: 2026-08-12T16:18:52.520629Z
updated: 2026-08-12T16:19:31.531506Z
type: task
title: The expanded view separates what a tile is from what it rests on
project: 01KX671DATY39VW6GWK3M2T3DN
number: 675
sprint: sdshnf8
blocked_by:
- 01KZVC99FJPV1T3TK3FQPC9XNY
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Once dependencies colour a tile, "why is this red" is unanswerable unless the drill-in shows them **and** says how each was reached. A flat list that silently mixes a namespace with the cluster underneath it is just a longer list.

Stacks on the Business Application task.

**Backend** — `ComponentState` (`dashboards.py:290-305`) and `ComponentStateRead` (`dashboards_api.py:139-152`) gain provenance: `origin` (`direct` | `inferred`), plus `via_edge_type`, `via_entity_name`, `depth` for inferred rows, and the source that contributed the row (a service can have several). `included_entities` already returns exactly this on `IncludedEntity` (`business_applications.py:813`) — carry it through rather than recomputing.
- `component_states` (`dashboards.py:311-369`) must keep using the **same** member set and the **same** webhook-excluded signal query as the evaluator, or the tile and its components disagree.
- Both reads return it: authenticated `GET /dashboards/{service_id}` and the public `GET /api/v1/board/{token}/services/{service_id}` — they share `component_states`. Provenance is status, not configuration, so the wall may have it.

**UI**
- `DashboardServicePage.tsx`: two sections — **Members** ("what this is made of") then **Depends on** ("what it rests on") — each troubled-first, each with its own healthy-tail elision (`TILE_CAP = 30`), so a big dependency set cannot push a failing member off the page.
- Each inferred tile says how it was reached, reusing the wording already on screen in `IncludedEntities.tsx:192-222`: `"{via_edge_type} from {via_entity_name} ({depth} hops)"`. Same words in both places or the estate speaks two dialects.
- `WallboardPage.tsx` drill-in: same two sections under `WALL_TILE_CAP = 24`, still fit-to-screen and never scrolling — the cap applies per section.
- A group-backed service has no inferred rows: the Depends-on section is absent, not an empty box.

**Tests** — vitest asserts inferred rows render under their own heading with the provenance line and that a group-backed service renders no such heading; backend tests assert `origin`/`via_*` survive to both reads; `Wallboard.test.tsx` covers the sectioned drill-in.