---
id: 01M7TNCPCMK9R32ADCR435MWB9
created: 2026-11-19T19:43:59.38054Z
updated: 2026-11-19T21:37:26.144484Z
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
assignee: steve
label:
- improvement
priority: high
task_status: review
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