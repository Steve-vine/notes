---
id: 01KZ3Q91TGZQG9F5C2GAH6XTTZ
created: 2026-08-03T11:48:50.640104Z
updated: 2026-08-05T19:02:26.694403Z
type: task
title: Evidence from a pack
project: 01KX671DATY39VW6GWK3M2T3DN
number: 505
sprint: syte7bx
assignee: steve
label: null
priority: medium
task_status: backlog
---
Pack-declared parameterised read queries surface as the integration's evidence catalogue (name + description + JSON Schema params, same shape as `evidence_catalogue()`), usable in incident investigations and over the MCP surface. Degrades to `EvidenceResult(ok=False)` on failure like any connector.