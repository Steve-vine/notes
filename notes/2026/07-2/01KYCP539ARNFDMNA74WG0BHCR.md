---
id: 01KYCP539ARNFDMNA74WG0BHCR
created: 2026-07-25T13:06:40.554823Z
updated: 2026-07-25T15:47:16.35231Z
type: task
title: Dashboard components drill-down — per-service board of member assets
project: 01KX671DATY39VW6GWK3M2T3DN
number: 292
sprint: sak4nk6
blocked_by:
- 01KYCP4V340HTE4BG5V5ZGTDM0
assignee: steve
priority: medium
task_status: backlog
---
Third slice: click a service tile → same-design board of its Components. Depends on ISE-291.

- Components = union of the service's group members (no per-component rules — rules live at service level only).
- Colour per entity derived from its worst present signal via `signal_state_for_entities` (medium → orange, high/critical → red, else green) — this answers "which asset is making it red" at a glance. Same webhook-System exclusion as the evaluator so the two levels never disagree.
- `GET /api/v1/dashboards/{id}` returns the service, its status, and per-component state in one call (batched, no N+1 — `signal_state_for_entities` already takes a list).
- Screen: component grid in the same tile design, breadcrumb back to the service board, component tile deep-links to entity detail (and worst signal/incident where present). Same poll interval as the main board.
- Empty membership shows the grey/unknown treatment with a hint ("no members resolve — check the service's groups"), never a green board.