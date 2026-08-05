---
id: 01KYCP539ARNFDMNA74WG0BHCR
created: 2026-07-25T13:06:40.554823Z
updated: 2026-08-05T12:31:34.234829Z
type: task
title: Dashboard components drill-down — per-service board of member assets
project: 01KX671DATY39VW6GWK3M2T3DN
number: 292
sprint: sak4nk6
blocked_by:
- 01KYCP4V340HTE4BG5V5ZGTDM0
comments:
- id: 01KYFMYBEBVAETAGMN4HW3SA9Y
  author: Steve Vine
  at: 2026-07-26T16:43:14.251805Z
  text: |-
    Done — PR #281 (feature/ise-292-dashboard-components, stacked on #280).

    Built:
    - dashboards.component_states: each member's worst present signal → per-asset colour (high/critical→alert, medium→warn, else ok). Same webhook-System exclusion as the evaluator so tile and components never disagree. Batched — one entity query, one signal query, one incident query (no N+1) — and sorted troubled-first (red, amber, then green).
    - GET /dashboards/{id} now returns DashboardServiceDetail: service + status + per-component state in one call (viewer read, no evaluation).
    - /dashboards/:serviceId components board: tiles in the same design, deep-link to entity detail (/estate/{id}) and to IN-nnnn incident where present, breadcrumb back, polled 12s. Green tail elides into a "+N healthy" tile so troubled assets stay full-size (~30 cap). Empty membership shows the grey "no members resolve" hint, never a green board. Main-board service tiles now click through here.

    Verified locally: real-Postgres component_states (colour-by-worst, webhook exclusion, troubled-first) + detail-endpoint + page tests green; mypy/ruff/build/lint/format clean.
assignee: steve
priority: medium
task_status: done
---
Third slice: click a service tile → same-design board of its Components. Depends on ISE-291.

- Components = union of the service's group members (no per-component rules — rules live at service level only).
- Colour per entity derived from its worst present signal via `signal_state_for_entities` (medium → orange, high/critical → red, else green) — this answers "which asset is making it red" at a glance. Same webhook-System exclusion as the evaluator so the two levels never disagree.
- `GET /api/v1/dashboards/{id}` returns the service, its status, and per-component state in one call (batched, no N+1 — `signal_state_for_entities` already takes a list).
- Screen: component grid in the same tile design, breadcrumb back to the service board, component tile deep-links to entity detail (and worst signal/incident where present). Same poll interval as the main board.
- **Scaling**: fit-to-screen like the service board — count-adaptive grid, no scrolling on the wallboard rendering. Sort troubled-first (red, amber, then green) so on a large membership the tiles that matter are always full-size; the green tail may shrink or elide into a "+N healthy" tile. Practical ceiling ~24–30 readable tiles.
- Component tiles carry entity kind + worst signal title (per the agreed mockup, see ISE-293).
- Empty membership shows the grey/unknown treatment with a hint ("no members resolve — check the service's groups"), never a green board.