---
id: 01KZ3Q8TASV92F34Q79Y6TPCZR
created: 2026-08-03T11:48:42.969488Z
updated: 2026-08-05T11:55:22.053648Z
type: task
title: Entities from a pack
project: 01KX671DATY39VW6GWK3M2T3DN
number: 503
sprint: s1mg25q
assignee: steve
priority: medium
task_status: backlog
---
Pack-declared endpoint + JSONPath mappings produce `EntityData` (native keys, tags, cross-keys, edges) through the normal `discover_entities` → `reconcile_discovered` path; source-of-record declared in the pack, rung-1 entity types only. Done = a pack-defined integration's entities visible in the Estate list and graph.