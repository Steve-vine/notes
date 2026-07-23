---
id: 01KY737K866RJZSHDYX41BAA84
created: 2026-07-23T08:59:47.33477Z
updated: 2026-07-23T20:03:45.748766Z
type: task
title: Note open in main screen issue
project: 01KY6W9951TW0904DT0GGJVGE7
number: 363
sprint: segj1dz
comments:
- id: 01KY7R7FT16GXZZFNVKY0G8VZB
  author: Steve Vine
  at: 2026-07-23T15:06:43.90481Z
  text: 'PR #356 (branch not-363-open-in-main-window): open-note from the capture window now opens the board overlay when the active tab isn''t Browse, so Esc returns to the Planner (or Dashboard/Workspace/Search) instead of stranding on a blank Browse pane. Needs a quick manual check in the app.'
assignee: steve
label:
- bug
priority: medium
task_status: active
---
When in planning mode, clicking the '+' at the bottom of a column to open a new note, filling in the note, then clicking the 'open in main window' button, it silently switches back to the Browse tab so that after editing the note and pressing escape, I'm looking at a blank screen on the browse tab rather than the planner again.

---

Linear DEV-1016 · Enhancements · created 2026-07-21 · backlog