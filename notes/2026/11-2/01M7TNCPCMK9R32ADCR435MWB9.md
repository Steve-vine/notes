---
id: 01M7TNCPCMK9R32ADCR435MWB9
created: 2026-11-19T19:43:59.38054Z
updated: 2026-11-20T14:05:05.086547Z
type: task
title: Shapes move to a narrow bar down the left of the canvas, so none overflow the top bar
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1993
sprint: s6y6p7g
comments:
- id: 01M7TVWB2B5RT806T39Z7NA641
  author: Steve Vine
  at: 2026-11-19T21:37:23.531102Z
  text: |-
    Done — PR #1990, merged 415c43b0.
    Every shape is off the flowchart editor's top bar and on a narrow bar down the left of the canvas, each as a small picture of itself. Line is at the end.
    Hovering over or tabbing to a shape shows its name and what it's for. Each button is named for screen readers.
    Order: Start/End, Step, Decision, then Document, Input/Output, Hand-off, then Note, Text, Group and Line.
    Clicking a shape adds it in view, and dragging one onto the canvas or onto a line places it there, as before.
    The top bar keeps only the other tools and no longer overflows at 1024px or 1280px wide. If the window is too short, the shapes bar scrolls. On a phone it runs across the top and scrolls sideways.
    Assumption: the bar follows Compass's own light or dark theme, as the right-hand panel does, not the canvas's background choice.
    The eight new shapes from COM-1992 join the bar's groups when that task lands. Until then, any shape not yet placed still shows on the bar.
    To check on staging: open a flowchart in a document, a standalone flowchart and full screen; add a shape by clicking and by dragging; make the window short.
- id: 01M7V3S4JQMMY8F1XC7SN2FJG8
  author: Steve Vine
  at: 2026-11-19T23:55:27.190825Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Passed
    - Narrow bar shows every shape (Line included) as a small picture; hover or focus shows name and hint: Passed. As E2E Admin A: 17 shapes plus Line, each drawn as a small outline. Hovering each one, and tabbing to it, showed its name and hint (e.g. "Data — A database or other stored data the flow reads or writes"; Line: "…drag on the canvas to draw it").
    - Click adds, drag onto canvas or onto a line places it, Line draws as before: Passed. Clicking added the shape (and keyboard Enter on a focused button did too). Dragging Preparation onto empty canvas dropped it under the pointer. Dragging Delay onto the Begin → Log the request line put it between them (Begin → Delay → Log the request). Line: click it, then drag on the canvas, and it draws.
    - Shapes off the top bar; the other tools stay; no overflow: Passed. Measured at 1024, 1280 and 1440 wide: the bar never scrolls and Done ends 14px inside the window.
    - Bar in a document's flowchart, a standalone flowchart and full screen, on light and dark canvases: Passed for a document's flowchart and a standalone one, each on light and dark canvases. There's one editor and it fills the window; full screen in the reading view has no editor.
    - Too short a window: the bar scrolls and stays usable: Passed. At 1280×480 the bar shows a scrollbar, and Line can be scrolled to and used.
    - Sensible order: Passed. Start/End, Step, Decision · Subprocess, Manual task, Preparation, Delay · Document, Documents, Data, Input/Output, Manual input · Hand-off, Connector · Note, Text, Group · Line.
    - Keyboard, names for screen readers, doesn't cover the canvas: Passed. The bar is a navigation landmark named "Shapes" and each button is named after its shape. The canvas starts at x=47, right beside the bar, and nothing overlaps it.
    - Tests: Passed. dropIn.test.tsx covers the bar's list, click-to-add and drag-to-add.
    Observations (not defects):
    - With a shape selected, clicking a shape on the bar adds it connected below the selected one. Clicking 16 in a row ran them off the bottom of the view, and the view didn't follow (r3-06).
    - Undoing a freshly drawn Line takes two Undos. The first leaves a short stub arrow where the line started (r3-13-line-a…d). Probably older than this task.
    - As the builder assumed, the bar stays light on a dark canvas.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1993/
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve's smoke test of round 2: the shapes already overflow the top bar of the flowchart editor. With the new shapes from COM-1992 there will be 18 in all: Start/End, Step, Decision, Document, Input/Output, Hand-off, Note, Group, Text and Line, plus Data, Subprocess, Documents, Manual input, Manual task, Preparation, Delay and Connector. Put every shape on a narrow bar down the left-hand side of the canvas instead.

**Done when**
- A narrow bar down the left of the canvas shows every shape, Line included, as a small picture of itself. Hovering or focusing one shows its name and hint.
- Clicking a shape adds it in view, and dragging one onto the canvas or onto a line places it there, as the top bar does today. Line draws as it does today.
- The shapes come off the top bar. The top bar keeps the other tools (undo/redo, lanes, styles, tidy up, zoom, Done…) and nothing on it overflows at the usual window widths.
- The bar is in the editor in a document, in a standalone flowchart and in full screen, on light and dark canvases.
- If the window is too short for every shape, the bar scrolls and stays usable.
- The shapes on the bar are in a sensible order, with the most used first: Start/End, Step, Decision, then the rest grouped.
- The bar works from the keyboard, each shape button is named for screen readers, and it doesn't cover the canvas: the canvas sits beside it.
- Tests cover the bar listing every shape and click-to-add and drag-to-add from it.

Relates to COM-1992 (more shapes). Whichever is built second places its shapes on the other's bar.

Independent: frontend editor only.