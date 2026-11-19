---
id: 01M7TMYNYNC0SKT2H4FEBQAYRQ
created: 2026-11-19T19:36:20.181749Z
updated: 2026-11-19T21:14:27.577384Z
type: task
title: 'More flowchart shapes: Data (database cylinder) and the other common ones'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1992
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve's smoke test of round 2: add more flowchart shapes, including Data (a database cylinder) and a few other common ones.

The shapes today are Start/End, Step, Decision, Document, Input/Output, Hand-off, Note, Group and Text.

New shapes, with the standard flowchart symbol for each:
- **Data**: a cylinder. A database or other stored data the flow reads or writes.
- **Subprocess**: a box with a double line down each side. A step that is a flow of its own, described elsewhere.
- **Documents**: a stack of documents. Several documents or records.
- **Manual input**: a box with a sloping top. Someone types or enters something.
- **Manual task**: a trapezium. A step done by hand, not by a system.
- **Preparation**: a hexagon. Setting up for a later step.
- **Delay**: a D shape. Waiting, such as for an approval or a set time.
- **Connector**: a small circle. Joins one part of the flow to another on the same page.

**Done when**
- Each new shape is on the shapes bar down the left of the canvas (COM-1993) with a hint saying what it's for. You can click it or drag it in.
- Each new shape is a step in the flow. It connects like any other step, takes styles (fill, border, text), resizes, and its words wrap and never hide.
- Each looks the same on the canvas, in the reading view, in the PNG and SVG downloads, and in the PDF and Word files, on light and dark canvases.
- The plain-text version of the flowchart names each one, e.g. "Data: Customer records".
- Imports from draw.io, Visio and Lucidchart turn their matching symbols into these shapes instead of plain steps.
- Polaris (the assistant) can draw and read the new shapes.
- Older flowcharts are unchanged.
- Tests cover drawing, the picture, the plain text and import mapping for each new shape.

Assumption (Claude): the set above is the usual flowchart set. Display, merge/extract and off-page connector are left out, and Hand-off already covers off-page.

On the chain: it adds shape kinds the server checks and the assistant's tools describe.