---
id: 01M7PVKAGVYDWC62B92V84JRQ3
created: 2026-11-18T08:15:30.331777Z
updated: 2026-11-18T09:01:02.694706Z
type: task
title: 'Flowchart canvas: the keyboard keeps working on a selected shape, and lanes resize by dragging their edge'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1933
sprint: s6y6p7g
comments:
- id: 01M7PY6M3HDF5W1XMC4FSASHPB
  author: Steve Vine
  at: 2026-11-18T09:00:59.888879Z
  text: |-
    Done — PR #1922, merged c5242d7e.
    - Selecting or adding a shape now leaves the keyboard on the canvas. Delete, Tab, the arrows and Ctrl+C/V act on the selected shape every time, and Backspace removes the shape instead of a letter of its label.
    - The Label box takes the keyboard only when you click into it. Escape, or a click on the canvas, hands the keyboard back with the shape still selected.
    - A lane's edge can now be dragged to resize it, whether the lanes run across or down. In a real browser, dragging a lane's edge grew it from 160 to 240 (across) and from 160 to 280 (down).
    - A new Note is never connected to anything, and nothing added after a Note is connected to it.
    - "Add a step after" (and Tab) on a shape that leads on to one other shape now puts the new step between them. The connection's label stays on the first half, and the shapes after it move along to make room without changing lane.
    Assumptions: after a Decision, "Add a step after" still starts a new branch, since that's what a Decision is for. The Label box no longer takes the cursor even right after a shape is added: click into it to type, as the task says.
    To check on staging: in a laned flowchart, drag a lane's bottom edge (lanes across) or right edge (lanes down). Select Start in Start → Step and press Tab: the new step should sit between them. Screenshots are in ~/compass-uat/s6y6p7g/COM-1905/com-1933-*.
assignee: steve
label:
- bug
priority: high
task_status: review
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