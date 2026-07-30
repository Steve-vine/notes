---
id: 01KYPBJE9V7R2JWNC88C4GFZQS
created: 2026-07-29T07:14:07.803049Z
updated: 2026-07-30T13:00:44.894581Z
type: task
title: Create an auto-archive setting
project: 01KY6W9951TW0904DT0GGJVGE7
number: 379
sprint: segj1dz
comments:
- id: 01KYSHK7S61G0DTA4VZZEM2DSR
  author: Steve Vine
  at: 2026-07-30T12:57:08.64588Z
  text: |-
    Up for review: PR #371 (branch not-379-auto-archive), with new ADR 0048 recording the design.

    Key design call (flagging for your review): archive is NOT a second trash. An archived task leaves the Kanban board but deliberately stays in search, browse, and its project's task list/sprint tallies — so sprint progress can't regress and filed-away work stays findable. If you'd rather archived tasks also vanish from browse (or want a dedicated Archive browser like the Trash section), that's a follow-up on top of this data model.

    What you get now: Settings › Projects › "Auto-archive completed tasks after N days" (empty = never; setting it sweeps immediately and reports how many went); an Archive button on a task's statusbar; an archived banner with Unarchive. "Completed" = any is_done status; the clock is the task's updated stamp, so touching an old done task keeps it around.

    Heads-up: index SCHEMA_VERSION bumped 7 → 8, so after merging + running the app, the debug MCP build should be rebuilt when convenient (its stale v7 index keeps working, just blind to archived).
assignee: steve
label: null
priority: medium
task_status: review
---
Create a setting to auto-archive completed tasks after a period of time. There is currently no archive feature so this will be needed as well. 