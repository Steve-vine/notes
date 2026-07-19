---
id: 01KXGX1W87B196TSA19V6F9SYZ
created: 2026-07-14T18:08:30.983469221Z
updated: 2026-07-14T18:08:41.229510295Z
type: task
title: Search filter
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 147
sprint: ssdk92z
comments:
- id: 01KXGX268DTZ2DHEEPVTN68DDH
  author: Steve Vine
  at: 2026-07-14T18:08:41.229396522Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-03 16:39 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/131 (stacked on #130). Adds a debounced "Search by name" box on the Content list backed by a new `q` param on `GET /api/v1/content` (case-insensitive title contains, wildcards escaped). Backend + frontend tests added.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Add a free text search filter on the content page to filter content by name.

---
*Migrated from Linear [DEV-793](https://linear.app/stevevine/issue/DEV-793/search-filter) · created 2026-07-03 · completed 2026-07-03*