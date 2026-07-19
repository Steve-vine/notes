---
id: 01KXGWXBN66MGB1N7XQRH0R645
created: 2026-07-14T18:06:02.918035563Z
updated: 2026-07-14T18:06:09.459967926Z
type: task
title: Delete content button
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 140
sprint: ssdk92z
comments:
- id: 01KXGWXJ1K1N5QX9XXQ63EJ68K
  author: Steve Vine
  at: 2026-07-14T18:06:09.459848461Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-03 16:47 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/133 (stacked on #132). Red "Delete…" button on the Edit tab with a confirmation modal; backed by a new `DELETE /api/v1/content/{slug}` (soft-delete, analyst/admin only). DEV-788's bulk delete will reuse the endpoint.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Add a Delete button to the content edit tab, with confirmation, that will delete the content completely

---
*Migrated from Linear [DEV-786](https://linear.app/stevevine/issue/DEV-786/delete-content-button) · created 2026-07-03 · completed 2026-07-03*  
*Related to (Linear): DEV-788*