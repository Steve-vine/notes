---
id: 01M3EBHPVD1AK3VMMZK29Q9AJ8
created: 2026-09-26T07:58:17.453596Z
updated: 2026-09-26T08:34:45.941583Z
type: task
title: The hide sidebar buttons are inconsistent
project: 01KY6W9951TW0904DT0GGJVGE7
number: 444
sprint: sqsolof
comments:
- id: 01M3EDMG1NAD4DAQR86VZE5FS1
  author: Steve Vine
  at: 2026-09-26T08:34:45.941275Z
  text: 'PR #447: the right panel''s footer button is now the sidebar glyph mirrored; the collapsed rails'' expand buttons take the same glyph and style; the pane-header toggles (and their props through Pane/NotePane) are removed. The pop-out window follows the same pattern.'
assignee: steve
priority: medium
task_status: review
tech: null
---
The hide left/right sidebar buttons are inconsistent across pages. They appear in the Bottom corners of the sidebars but the right hand one is the old style '>' icon, they also appear in the top line of the Browse page.

Replace the bottom right button to the new style and remove the top line ones on the Browse page.