---
id: 01M3HJMQWWVBZ143V15PYFABM1
created: 2026-09-27T14:00:00.156519Z
updated: 2026-09-27T14:01:19.598132Z
type: task
title: Split from a note opened over Search, Planner, Dashboard or Schedules
project: 01KY6W9951TW0904DT0GGJVGE7
number: 451
sprint: sqsolof
comments:
- id: 01M3HJQ5FEC0B4Y4SQQSXFV2PC
  author: Steve Vine
  at: 2026-09-27T14:01:19.597692Z
  text: 'PR #454. Verified in a WKWebView lab that the real NotePane''s ⋯ menu shows both Split entries whenever it has a split callback and none without one — the floating note was the only in-app pane without it. Split there now closes the overlay, switches the tab to Browse, opens the note in the active pane in the same mode, and splits that pane.'
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
A note opened from the Browse tree offers Split left / right and Split top / bottom in its ⋯ menu. The same note opened from Search, the Planner, the Dashboard, Schedules or a Workspace floats over that view and its ⋯ menu has no Split entries — that overlay has never been part of the pane tree. Since the redesign those views are the main way notes get opened, so splitting reads as missing.

Split from the overlay should take the note into the Browse view's pane tree and split it there, keeping the current Read/Live/MD mode.