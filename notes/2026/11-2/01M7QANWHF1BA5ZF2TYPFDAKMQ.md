---
id: 01M7QANWHF1BA5ZF2TYPFDAKMQ
created: 2026-11-18T12:39:02.959333Z
updated: 2026-11-18T13:18:27.027675Z
type: task
title: Colour a flowchart shape's fill and border, and a connection's line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1942
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve, testing on staging, 2026-11-18: a colour picker for a shape's background and border, and for a connection's line, would be a useful addition. Steve, same day: the picker also needs a Transparent option, so a shape can have no fill or no border (the new Text shape, COM-1956, starts that way).

**What the author sees**
- With one or more shapes selected, the side panel has **Fill** and **Border** colour pickers. With connections selected, it has **Line** (and its arrowhead).
- Each picker offers, in order:
  - **Transparent**, for no fill or no border, shown as a chequered swatch (Fill and Border only, since a line must be seen);
  - the house style's colours;
  - any colour, by picker or hex code;
  - **Default**, which puts it back to the house style.
- A shape's text automatically turns light or dark so it stays readable on whatever fill is chosen. On a Transparent fill, it's readable on whatever lies behind (canvas or lane).
- A shape with a transparent fill and border still shows a faint outline while selected on the canvas, so it can be found and grabbed. The picture and exports don't show that outline.
- Colours apply to everything selected at once, and each change is one undoable step.
- Copy/paste keeps colours.

**What a reader sees**
- The reading view, PDF, Word and downloads show the chosen colours, including transparent fills and borders.
- In dark mode on screen, a chosen colour stays the same colour, and text stays readable on it. House-style defaults still follow the theme as now.

**Done when**
- Fill, Border and Line colours can be set on any shape or connection (one or several), including Transparent for Fill and Border, reset to Default, and are kept after Done, publishing and reopening.
- Shape text is always readable on its fill, including Transparent.
- A fully transparent shape can still be seen and selected on the canvas.
- Colours show in the reading view (light and dark), PDF, Word and downloads.
- Compare versions mentions a colour change in words (e.g. "Step 'Approve' fill changed").
- Tests cover setting, resetting, Transparent, multi-select and text contrast.

Independent unless the stored chart needs a new field the server must accept (then on the chain).