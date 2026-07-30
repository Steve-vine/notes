---
id: 01KYPBEMHM6DC2DMPWHX89STAJ
created: 2026-07-29T07:12:03.124372Z
updated: 2026-07-30T13:16:47.399398Z
type: task
title: Add a max cards setting
project: 01KY6W9951TW0904DT0GGJVGE7
number: 378
order: 1.0
sprint: segj1dz
comments:
- id: 01KYSG81FDNXCFYJBPDSKFSB38
  author: Steve Vine
  at: 2026-07-30T12:33:33.164998Z
  text: |-
    Up for review: PR #370 (branch not-378-max-cards-setting).

    Settings › Projects gains a "Kanban board" group with "Max cards per column" (empty = no limit). The cap applies after filters and sort, so it elides the correct tail; a capped column shows "+N more" under the stack, and the header count stays at the column's true total. Per-machine preference, applied live.

    Note: this PR touches KanbanView near PR #369's changes — whichever merges second may need a trivial rebase; happy to handle it.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Create a setting for the maximum number of items shown in any column in Kanban view to prevent the Done column becoming massive.