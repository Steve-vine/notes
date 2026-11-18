---
id: 01M7QB3YD6SPB5WYMEF0W8NQEB
created: 2026-11-18T12:46:43.622843Z
updated: 2026-11-18T12:46:49.977901Z
type: task
title: 'Flowchart line styles: right-angled, straight or curved; arrows at either, both or no end; solid, dashed or dotted; line weight'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1944
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve, testing on staging, 2026-11-18: more line styles are needed.

**What the author sees**
With one or more connections selected, the side panel offers:
- **Route:** Right-angled (today's, routed around steps), Straight, or Curved.
- **Arrows:** at the end (today's default), at the start, at both ends, or none.
- **Pattern:** Solid, Dashed or Dotted.
- **Weight:** Thin, Normal (today's) or Thick, about 1, 2 and 3.5 pt.
These sit with the Line colour from COM-1942. They apply to everything selected, each change is one undoable step, and copy/paste keeps them.

**How the routes behave**
- Right-angled keeps COM-1931/1935's rules: never through a step, never sharing a line or arrowhead.
- Straight and Curved go directly between the two shapes. They may cross a step if the author places shapes so. Their labels still sit clear of steps.
- Tidy up keeps each connection's chosen style.

**What a reader sees**
- The reading view, PDF, Word and downloads show every style, arrow, pattern and weight.

**Meaning**
- The flow's direction for plain text, search and Polaris still follows the connection's from → to.
- Arrows are drawing only: an arrow at both ends or none doesn't change the steps in words.
- Compare versions mentions a style change in words.

**Done when**
- Each option above can be set on one or several connections, is kept after Done, publishing and reopening, and shows identically on the canvas, in the reading view, PDF, Word and downloads.
- Right-angled lines keep their routing guarantees, and every label stays visible for all three routes.
- Tests cover each option and the plain-text steps staying the same.

Independent unless the stored chart needs new fields the server must accept (then on the chain). Shares the side panel with COM-1942.