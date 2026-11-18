---
id: 01M7PVKAGVYDWC62B92V84JRQ3
created: 2026-11-18T08:15:30.331777Z
updated: 2026-11-18T08:15:42.509311Z
type: task
title: 'Flowchart canvas: the keyboard keeps working on a selected shape, and lanes resize by dragging their edge'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1933
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Pre-UAT, 2026-11-18 (tester A, COM-1904/1905):
- **Keyboard:** after adding any shape, clicking a shape moves the cursor into the side panel's Label box. Delete, Tab, the arrow keys and Ctrl+C then do nothing to the shape. Backspace deletes the label's last letter ("End" became "En"), and the arrows move one shape once and stop. On a freshly opened canvas with nothing added, the keys work. Screenshot: ~/compass-uat/s6y6p7g/COM-1904/03-backspace-edits-label.png
- **Lanes:** a lane can't be resized by dragging its edge, because the edge never gets the pointer. COM-1905 promised resizing.
- Also seen:
  - adding a Note while a shape is selected joins the Note to that shape (a Note isn't a step and shouldn't be connected);
  - "Add a step after" on a shape that already leads somewhere starts a new branch instead of inserting the step between them.

**Done when**
- Selecting a shape keeps the keyboard on the canvas: Delete, Tab, the arrows and Ctrl+C/V act on the selection, every time. The Label box takes the keyboard only when the person clicks into it, and Escape returns it to the canvas.
- A lane's edge can be dragged to resize it, in both lane directions.
- A new Note is never connected to anything.
- "Add a step after" inserts the step between the shape and what it led to.
- Tests cover each of these.

Independent: frontend only.