---
id: 01M7QAHRVFQTWX92R8ESJ9DD1J
created: 2026-11-18T12:36:48.111792Z
updated: 2026-11-18T12:36:50.605452Z
type: task
title: Double-click a flowchart shape to edit its label right on the canvas
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1941
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve, testing on staging, 2026-11-18: for speed, double-clicking a shape should let you edit its label where it is, instead of selecting it and then clicking into the Label box in the side panel.

**What the author sees**
- Double-clicking a shape (or pressing Enter or F2 with it selected) turns its label into an edit box in place, sized to the shape, with the text selected.
- Typing changes the label live, and the side panel's Label box follows. The shape grows to fit as COM-1940 sets out, so the text is never hidden.
- Enter keeps the change, Shift+Enter adds a new line, and Escape cancels. Clicking elsewhere also keeps it.
- After editing, the keyboard goes back to the canvas, so Delete, Tab and the arrows act on the shape again (as COM-1933 set up).
- Double-clicking a connection edits its label (e.g. Yes / No) the same way. Double-clicking empty canvas does nothing new.
- Each edit is one undoable change.

**Done when**
- A label can be edited in place by double-click, Enter or F2, for every shape and for connection labels, with Enter, Shift+Enter, Escape and click-away behaving as above.
- The side panel and the in-place edit always show the same text.
- The keyboard returns to the canvas afterwards.
- Tests cover editing, cancelling and a multi-line label.

Independent: frontend. Builds on COM-1940 for shapes growing to fit.