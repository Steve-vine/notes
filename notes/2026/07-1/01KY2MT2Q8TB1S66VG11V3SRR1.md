---
id: 01KY2MT2Q8TB1S66VG11V3SRR1
created: 2026-07-21T15:30:46.632842Z
updated: 2026-07-21T22:10:20.730476Z
type: task
title: Groups in the Estate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 184
order: 2.0
sprint: sth83hw
blocked_by:
- 01KY2MT1Q10BDC3CDXJVBX80HC
assignee: steve
label: null
priority: medium
task_status: done
---
Groups become visible, traversable estate citizens: Estate list/filter includes type `group` (+ `_ENTITY_TYPE_PATTERN`); `EntityGraphView` renders group nodes distinctly (rounded rect, violet) vs entity circles; group detail page shows Members panel (depth-1 `part-of`), rolled-up member alerts (`GET /entities/{id}/signals` gains a members branch for groups), and a "built by rule" link to Settings.

**Accept:** the "Kora" group appears in Estate and in members' graphs via `part-of` spokes; clicking it shows members, their alerts rolled up, and the owning rule; no incident is ever opened by any of this (ADR 0034).