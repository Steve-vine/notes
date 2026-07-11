---
id: 01KX8GYJEGGCPKKA5YR89BTCT6
created: 2026-07-11T12:03:04.27278408Z
updated: 2026-07-11T16:22:26.955165148Z
type: task
title: UI — Overview live system cards
assignee: steve
task_status: todo
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 27
blocked_by:
- 01KX8GY8VRP7405VR5X6MYFNGV
sprint: sdm5e08
---
Replace the Overview empty state with one card per configured system (ui-brief): health, connection status, last sync + staleness pill (green fresh / yellow ageing / red stale), open issue count by severity. Estate-wide strips: open issues, recent audit activity. Everything clicks through. Uses generated types; per-screen polling.