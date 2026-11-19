---
id: 01M7TNCPCMK9R32ADCR435MWB9
created: 2026-11-19T19:43:59.38054Z
updated: 2026-11-19T19:43:59.38054Z
type: task
title: Shapes move to a narrow bar down the left of the canvas, so none overflow the top bar
assignee: steve
priority: high
label: improvement
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1993
---
Steve's smoke test of round 2: the shapes already overflow the top bar of the flowchart editor. With the new shapes from COM-1992 there will be 18 in all (Start/End, Step, Decision, Document, Input/Output, Hand-off, Note, Group, Text, plus Data, Subprocess, Documents, Manual input, Manual task, Preparation, Delay and Connector). Put every shape on a narrow bar down the left-hand side of the canvas instead.

**Done when**
- A narrow bar down the left of the canvas shows every shape as a small picture of itself. Hovering or focusing one shows its name and hint.
- Clicking a shape adds it in view, and dragging one onto the canvas or onto a line places it there, as the top bar does today.
- Free Line keeps working the same way, wherever its button ends up.
- The shapes come off the top bar. The top bar keeps the other tools (undo/redo, lanes, styles, tidy up, zoom, Done…) and nothing on it overflows at the usual window widths.
- The bar is in the editor in a document, in a standalone flowchart and in full screen, on light and dark canvases.
- If the window is too short for every shape, the bar scrolls and stays usable.
- The shapes on the bar are in a sensible order, with the most used first: Start/End, Step, Decision, then the rest grouped.
- The bar works from the keyboard, each shape button is named for screen readers, and it doesn't cover the canvas: the canvas sits beside it.
- Tests cover the bar listing every shape and click-to-add and drag-to-add from it.

Relates to COM-1992 (more shapes). Whichever is built second places its shapes on the other's bar.

Independent: frontend editor only.