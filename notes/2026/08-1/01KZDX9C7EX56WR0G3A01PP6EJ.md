---
id: 01KZDX9C7EX56WR0G3A01PP6EJ
created: 2026-08-07T10:46:17.07093Z
updated: 2026-08-07T15:49:47.563997Z
type: task
title: Bug surfaced by Claude code
project: 01KY6W9951TW0904DT0GGJVGE7
number: 397
sprint: segj1dz
comments:
- id: 01KZEEMVNND735YKKG787AGDX5
  author: Steve Vine
  at: 2026-08-07T15:49:39.122637Z
  text: |-
    PR #388. The reported trigger doesn't reproduce — a sprint-only patch round-trips labels fine (now covered by a test). Tracing the vault's git history through the 2026-08-07 incident found two real faults instead, both silent:

    1. `ops::patch_note` treated `values` as a full replacement, so changing one field with a partial map unapplied `label` on that task — and ADR 0027's family sweep then stripped `label`, values and all, from all 176 tasks in the ISE project. Fixed by ADR 0052: `values` now patches key by key; a key you leave out is left alone, and removal needs an explicit `null`. The app editor's full-replace flush is deliberately unchanged.

    2. Moving a task between projects deleted its task-scoped taxonomies. Rule 4 drops keys "the target project doesn't carry", but a task-only taxonomy can never sit on a project note (ADR 0027's own "scope applies per target"), so every move lost it. The drop is now scope-filtered like the matching `added` direction.

    The MCP sidecar needs rebuilding for the running vault to pick this up.
assignee: steve
priority: medium
task_status: review
---
The following bug was reported by Claude Code while creating a new sprint and moving three existing tasks into it.

One new Notuvia quirk surfaced along the way, now recorded in memory: assigning a sprint via update_note silently drops the task's label values
  even though nothing else in the values map is touched — all three tasks lost their labels on assignment and read back clean otherwise. I
  verified with get_note and re-saved the full values map on each, so labels (improvement / tech-debt / feature), priorities, statuses, and
  assignee are all intact now.