---
id: 01KZ3Q875ZTTT18Q6DFVDJDXY7
created: 2026-08-03T11:48:23.35968Z
updated: 2026-08-03T11:48:23.35968Z
type: task
title: Frontend entity-type lists generated, not hand-mirrored
label: tech_debt
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 499
---
`ENTITY_TYPES` is manually copied in three places (`EstatePage.tsx:45`, `TagDictionaryCard.tsx:34`, `SystemDetailPage.tsx:790`). Expose the canonical list via the API/OpenAPI snapshot and consume it in one shared module; the `EntityGraphView` icon map keeps its safe fallback. A new entity type then reaches the frontend via the existing generate:api step alone.