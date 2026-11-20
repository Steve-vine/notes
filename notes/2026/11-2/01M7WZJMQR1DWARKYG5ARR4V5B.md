---
id: 01M7WZJMQR1DWARKYG5ARR4V5B
created: 2026-11-20T17:20:28.920671Z
updated: 2026-11-20T17:45:01.022024Z
type: task
title: A flowchart's Zoom, Full screen and Download buttons can be seen and clicked on the Edit tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2035
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Claude's pre-UAT round 4 (staging b65d7ed8, tester B).

On the Edit tab, a flowchart's Zoom, Full screen and Download buttons sit underneath its picture, so they can't be seen or clicked. The tester could only open full screen by script. The Read tab is fine. COM-2004 gave every picture these buttons, so this may be a regression from COM-2022, which changed the flowchart block's stacking, or from COM-2027's picture changes.

**Done when**
- On the Edit tab, a flowchart's Zoom, Full screen and Download buttons show and work, for a document's own flowchart and for a standalone one, with "Show as on paper" on and off, selected and not.
- They still go under the sticky section toolbar when scrolled (COM-2022).
- Images and text diagrams are checked too.
- A test checks the buttons are on top of the picture and clickable.