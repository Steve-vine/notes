---
id: 01KZVC9YZ8QQMCW5YZX8J0P40C
created: 2026-08-12T16:18:52.520629Z
updated: 2026-08-12T17:38:16.387096Z
type: task
title: The expanded view separates what a tile is from what it rests on
project: 01KX671DATY39VW6GWK3M2T3DN
number: 675
sprint: sdshnf8
blocked_by:
- 01KZVC99FJPV1T3TK3FQPC9XNY
comments:
- id: 01KZVGV9Z07Z4VKF8W3JENG8HQ
  author: Steve Vine
  at: 2026-08-12T17:38:15.136613Z
  text: |-
    Done — PR #626 merged to main as 24b8ab4. Full CI green.

    ComponentState now carries origin (direct | inferred), the source that contributed it, and for an inferred row the via_edge_type, via_entity_name and depth. It is CARRIED, not recomputed: IncludedEntity has recorded exactly this since ISE-655, so threading it through cost nothing. The via-entity is always a member and therefore already in the entity map, so naming it adds no query.

    Both reads have it — the authenticated detail and the public wallboard drill-in share component_states. Provenance is status, not configuration, so the wall is allowed it.

    Screens: two sections, Members then Depends on, each with its own troubled-first order and its own healthy-tail elision so a big dependency set cannot push a failing member off the page. On the wall the legibility cap is SPLIT between the sections rather than applied twice — the whole board still has to fit one screen. A group-backed service has no dependencies, so the section is absent rather than an empty box.

    The empty board now repeats the tile's own status detail instead of the old generic "check the service's groups", which was wrong for two of the three source kinds.

    Two things found doing it:

    1. **jsdom makes `useIdle` report idle immediately** — no pointer or key event ever arrives — and an idle drill-in navigates straight back to the grid. A wallboard drill-in test therefore silently asserts against the GRID and fails with a confusing "cannot find text" against the wrong page. The pre-existing fallback test passed either way because the grid is what IT asserts, so this had been latent. The new test mocks the hook.
    2. `reachedVia` started life exported from DashboardServicePage and imported by WallboardPage — a page importing a formatter from another page. Moved to dashboardStatus.ts beside tileBackground / levelWord / assetSummary, which is where the shared tile vocabulary lives.
assignee: steve
label:
- feature
priority: medium
task_status: review
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