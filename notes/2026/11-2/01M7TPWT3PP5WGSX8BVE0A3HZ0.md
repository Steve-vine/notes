---
id: 01M7TPWT3PP5WGSX8BVE0A3HZ0
created: 2026-11-19T20:10:16.054997Z
updated: 2026-11-19T20:10:21.065017Z
type: task
title: A flowchart in a document is shown at its own size and can be resized from its corner
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1998
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Steve's smoke test of round 2: he created a small flowchart with 3 or 4 shapes in a document and pressed OK. It appeared across the full width of the page, so three shapes took up a whole A4 page. There's no way to resize it.

**Done when**
- A flowchart placed in a document starts at its own size: its shapes and words at about the size they are on the canvas at 100%. It's never wider than the page column and is never stretched to fill it.
- A flowchart in the document editor has a resize handle on its bottom-right corner, like pictures (see COM-1997). The handle stays on the corner as you drag. Dragging resizes the flowchart and keeps its proportions, down to a sensible minimum where the words can still be read.
- The flowchart can be aligned left, centre or right, like a picture. Its caption and Links stay with it.
- The chosen size is saved with the document. The reading view, PDF and Word all show the flowchart at that size, as a share of the page width. The 1960 rule still holds: a flowchart is always whole on one page.
- Editing the flowchart later keeps the size the person chose. A flowchart that grows past the column is capped at the column width.
- The same applies to a standalone flowchart shown in a document.
- Existing flowcharts in documents that never had a size set are shown at their own size from now on, capped at the column width. They're no longer stretched, in the editor, reading view, PDF and Word.
- Tests cover a small flowchart not filling the width, resizing it, and the size reaching the reading view, PDF and Word.

Relates to COM-1997, the corner handle for pictures. Share the handle, don't build a second one.

Independent: the size sits on the document's flowchart block, like a picture's width. If the PDF/Word render needs the API to carry it, this joins the chain.