---
id: 01M7TPWT3PP5WGSX8BVE0A3HZ0
created: 2026-11-19T20:10:16.054997Z
updated: 2026-11-19T20:28:41.185992Z
type: task
title: A flowchart in a document is shown at its own size in the editor and can be resized from its corner
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1998
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Steve's smoke test of round 2: he created a small flowchart with 3 or 4 shapes in a document and pressed OK. In the editor it appeared across the full width of the page, so three shapes took up a whole A4 page. There's no way to resize it.

Steve added: the Read tab and print preview already show the 3-box flowchart at a sensible size. So the editor is the odd one out (see COM-2000). What's missing everywhere is a way to choose the size.

**Done when**
- In the editor, a flowchart placed in a document is the same sensible size the Read tab and print preview give it. It's never stretched to fill the column.
- A flowchart in the document editor has a resize handle on its bottom-right corner, like pictures (see COM-1997). The handle stays on the corner as you drag. Dragging resizes the flowchart and keeps its proportions, down to a sensible minimum where the words can still be read.
- The flowchart can be aligned left, centre or right, like a picture. Its caption and Links stay with it.
- The chosen size is saved with the document. The Read tab, print preview, PDF and Word all show the flowchart at that size, the same as the editor. The 1960 rule still holds: a flowchart is always whole on one page.
- Editing the flowchart later keeps the size the person chose. A flowchart that grows past the column is capped at the column width.
- The same applies to a standalone flowchart shown in a document.
- A flowchart that has never been resized keeps the size the Read tab and print give it today. Nothing already published changes size.
- Tests cover:
  - a small flowchart not filling the width in the editor;
  - resizing it;
  - the size reaching the Read tab, PDF and Word.

Relates to:
- COM-1997 (the corner handle for pictures): share the handle, don't build a second one;
- COM-1999 (the settings panel);
- COM-2000 (the editor matches the finished product).

Independent: the size sits on the document's flowchart block, like a picture's width. If the PDF/Word render needs the API to carry it, this joins the chain.