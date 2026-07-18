---
id: 01KXGXF4DM8Q5DPFZFW96ZKHD5
created: 2026-07-14T18:15:45.332372208Z
updated: 2026-07-18T17:25:29.050113Z
type: task
title: New content review date and reviewer
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 156
label: null
comments:
- id: 01KXGXFBQJ5QSDAT6RJ9MCJAPQ
  author: Steve Vine
  at: 2026-07-14T18:15:52.818694083Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 09:19 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/146 (stacked on #145). Server-side on create: next review = today + the type's cadence (unscheduled if the type has none), reviewers = the creating user when none given. Explicit values via the API are respected.
sprint: ssdk92z
---
When adding new content, always add the review date, based on the setting for the content type, and add the user creating it as the reviewer.

---
*Migrated from Linear [DEV-819](https://linear.app/stevevine/issue/DEV-819/new-content-review-date-and-reviewer) · created 2026-07-04 · completed 2026-07-04*