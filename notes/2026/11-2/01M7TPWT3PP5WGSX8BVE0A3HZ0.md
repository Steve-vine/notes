---
id: 01M7TPWT3PP5WGSX8BVE0A3HZ0
created: 2026-11-19T20:10:16.054997Z
updated: 2026-11-19T21:40:12.468862Z
type: task
title: A flowchart in a document is shown at its own size in the editor and can be resized from its corner
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1998
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Steve's smoke test of round 2: he created a small flowchart with 3 or 4 shapes in a document and pressed OK. In the editor it appeared across the full width of the page, so three shapes took up a whole A4 page. There's no way to resize it.

Steve added that this only happens in one of the ways a flowchart can be shown:
- The Read tab and print preview already show the 3-box flowchart at a sensible size.
- A standalone flowchart added to a document already shows at a sensible size in the Edit tab too.

So only the document's own flowchart, in the Edit tab, is stretched. The editor is the odd one out (see COM-2000). What's missing everywhere is a way to choose the size.

**Done when**
- In the Edit tab, a document's own flowchart is shown the way a standalone flowchart added to a document already is: the same sensible size the Read tab and print preview give it. It's never stretched to fill the column. Both kinds share one way of being shown, so they can't drift apart again.
- A flowchart in the document editor, whether the document's own or a standalone one, has a resize handle on its bottom-right corner, like pictures (see COM-1997). The handle stays on the corner as you drag. Dragging resizes the flowchart and keeps its proportions, down to a sensible minimum where the words can still be read.
- The flowchart can be aligned left, centre or right, like a picture. Its caption and Links stay with it.
- The chosen size is saved with the document. The Read tab, print preview, PDF and Word all show the flowchart at that size, the same as the editor. The 1960 rule still holds: a flowchart is always whole on one page.
- Editing the flowchart later keeps the size the person chose. A flowchart that grows past the column is capped at the column width.
- A flowchart that has never been resized keeps the size the Read tab and print give it today. Nothing already published changes size.
- Tests cover:
  - a document's own small flowchart being the same size in the Edit tab as the same flowchart added as a standalone one, and as in the Read tab;
  - resizing it;
  - the size reaching the Read tab, PDF and Word.

Relates to:
- COM-1997 (the corner handle for pictures): share the handle, don't build a second one;
- COM-1999 (the settings panel);
- COM-2000 (the editor matches the finished product);
- COM-2001 (one click selects).

Independent: the size sits on the document's flowchart block, like a picture's width. If the PDF/Word render needs the API to carry it, this joins the chain.