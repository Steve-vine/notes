---
id: 01KZDX9C7EX56WR0G3A01PP6EJ
created: 2026-08-07T10:46:17.07093Z
updated: 2026-08-07T10:46:17.07093Z
type: task
title: Bug surfaced by Claude code
assignee: steve
priority: medium
sprint: segj1dz
task_status: backlog
project: 01KY6W9951TW0904DT0GGJVGE7
number: 397
---
The following bug was reported by Claude Code while creating a new sprint and moving three existing tasks into it.

One new Notuvia quirk surfaced along the way, now recorded in memory: assigning a sprint via update_note silently drops the task's label values
  even though nothing else in the values map is touched — all three tasks lost their labels on assignment and read back clean otherwise. I
  verified with get_note and re-saved the full values map on each, so labels (improvement / tech-debt / feature), priorities, statuses, and
  assignee are all intact now.