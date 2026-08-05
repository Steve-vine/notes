---
id: 01KZ3Q8WHVYE6K9CH2Y42ZQQXQ
created: 2026-08-03T11:48:45.243244Z
updated: 2026-08-05T13:25:23.223537Z
type: task
title: Alerts from a pack
project: 01KX671DATY39VW6GWK3M2T3DN
number: 504
sprint: s1mg25q
assignee: steve
label: null
priority: medium
task_status: backlog
---
Pack-declared alert mappings produce `FindingData` (source_key, severity mapping, entity_key resolution) through the normal `detect` → `reconcile_findings` → promotion path; ignore rules and severity caps apply server-side as for any connector. Done = a pack-defined integration's alerts flowing into Signals and Incidents in the UI.