---
id: 01KY2MT0R9685DXTCQ53NABPN1
created: 2026-07-21T15:30:44.617616Z
updated: 2026-07-21T15:30:44.617616Z
type: task
title: Tag drilldown page
task_status: backlog
label: feature
priority: medium
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 182
---
`GET /tags/{tag_id}?window=&system_id=` (id-based, avoids URL-encoding tag values) → tag header with per-integration source badges, entities table (rows link to Estate), in-window alerts list. `/tags/:tagId` route; cloud tags and entity-detail badges click through, carrying window/integration params. [Regenerate API types]

**Accept:** clicking `env:prod` lists its entities (linking to Estate) and the alerts heating it, honouring the carried window/integration filters.