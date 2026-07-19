---
id: 01KXGXFHSZX59FP6H16YPGJD64
created: 2026-07-14T18:15:59.039088606Z
updated: 2026-07-14T18:17:20.393143669Z
type: task
title: Update PDF added Review Record section
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 157
sprint: ssdk92z
comments:
- id: 01KXGXFVDTJ8J3724B6HPGYT6T
  author: Steve Vine
  at: 2026-07-14T18:16:08.890235809Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 10:38 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/148. Title is now "Document Review", left-aligned; the table is monochrome (light-grey header, grey grid, alternating white/light-grey rows). Renderer cache version bumped so existing exports regenerate with the new page. Verified with a sample render.
- id: 01KXGXG1AB5D3NQ414DM9FRNKD
  author: Steve Vine
  at: 2026-07-14T18:16:14.923632117Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 10:53 UTC]
    Merged (#148 → `6d3be44`) and deployed: image `main-20260704-1049`, helm rev 69 — all workloads Ready, `/readyz` + `/` 200. The renderer cache bump means any export you regenerate now carries the new monochrome "Document Review" page.
assignee: steve
label: null
priority: medium
task_status: done
---
Change the title from "Review record" to "Document Review" and change the title to be left aligned.

Change the table to monochrome.

---
*Migrated from Linear [DEV-821](https://linear.app/stevevine/issue/DEV-821/update-pdf-added-review-record-section) · created 2026-07-04 · completed 2026-07-04*