---
id: 01KXGTVCR3C4JTHXAW8PMJ0WH4
created: 2026-07-14T17:30:01.347151496Z
updated: 2026-07-14T17:30:11.929703718Z
type: task
title: Add review period when publishing a policy
label:
- feature
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 100
sprint: sg31rps
comments:
- id: 01KXGTVQ2S5PPB569SS84K21KP
  author: Steve Vine
  at: 2026-07-14T17:30:11.929598023Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-29 21:17 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/104 — **stacked on #103 → #102** (base = `dev-717` branch; GitHub retargets to `main` as the stack merges).

    The Publish modal gains an editable **Next review date** box and a **Mark as reviewed** checkbox:

    - `ContentPublish` gains `next_review_at` (date|None) + `mark_reviewed` (bool). Publish persists `next_review_at` **only when sent** (`exclude_unset`, so legacy publishes don't touch review dates) and, when `mark_reviewed`, records a review + stamps "Last reviewed" via the shared `_apply_review` helper (`reschedule=False` — the box owns the next date).
    - Modal box defaults to the existing `next_review_at`, else **today + the type's cadence** (clamping `addMonths` mirrors the backend). `usePublishContent` now takes `{changeNote, nextReviewAt, markReviewed}`.
    - No migration.

    Green: backend full integration suite **200 passed** (ruff/format/mypy clean) · frontend **125/125**.

    **M22 complete** — all three briefs (DEV-715 #102 → DEV-717 #103 → DEV-716 #104) are in review as a stack.
---
When publishing content, in the Publish Content model add a next review date box. If a next review date is already set for that content, add that date.  If no date is currently set, add a date based on the duration for that content type in settings from today.   The date should also be changeable and saves the date on publish if changed.

Add a tickbox for 'Mark as reviewed'.  If this is ticked, update the Last Review and Next Review dates and add an entry to the Review record.

---
*Migrated from Linear [DEV-716](https://linear.app/stevevine/issue/DEV-716/add-review-period-when-publishing-a-policy) · created 2026-06-29 · completed 2026-06-29*  
*Related to (Linear): DEV-717, DEV-715*