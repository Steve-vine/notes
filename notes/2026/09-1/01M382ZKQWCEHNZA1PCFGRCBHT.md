---
id: 01M382ZKQWCEHNZA1PCFGRCBHT
created: 2026-09-23T21:33:09.244812Z
updated: 2026-09-24T19:27:51.354796Z
type: task
title: 'UI redesign: pane header row and the ⋯ menu'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 433
sprint: sqsolof
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
Replace the note statusbar with the design's header row, per pane (splits behave as today):
- Left: sidebar toggle, breadcrumb (Type › Title).
- Right: Read/Live/MD segmented switch, star, ⋯ menu, then the right-panel toggle at the far right.
- ⋯ menu holds every current statusbar action not in the row: History, Open in new window, Split right, Split down, Duplicate, Encrypt/lock, Archive (tasks), Print, Add to workspace, Width toggle, Close pane, Move to Trash. Attach moves to the insert menu.
- Updated timestamp moves to the meta line above the title.