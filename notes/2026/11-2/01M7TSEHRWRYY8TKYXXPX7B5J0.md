---
id: 01M7TSEHRWRYY8TKYXXPX7B5J0
created: 2026-11-19T20:54:54.492216Z
updated: 2026-11-19T20:54:57.399912Z
type: task
title: Images, diagrams and flowcharts share the same reading tools and the same settings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2004
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve's smoke test of round 2: the different kinds of picture in a document don't offer the same things.
- In the Read tab, flowcharts have Zoom in/out, Full screen and Download, but images and diagrams don't.
- In the editor, images and diagrams have alignment, caption and alt text, but flowcharts don't.

All of them should have the same set.

The kinds are uploaded images, drawings (Excalidraw), text diagrams, and flowcharts (a document's own or a standalone one).

**Done when**
- **Reading tools, for every kind (Read tab and shared views):**
  - Zoom in and Zoom out, with steps relative to the size it's shown at (COM-2003).
  - Full screen.
  - Download. An image downloads as its original file. A drawing or text diagram downloads as PNG or SVG. A flowchart downloads as now.
  - The tools look and sit the same for every kind. They show on hover or focus, so a small picture isn't covered, and work from the keyboard.
- **Settings, for every kind (in the editor's settings panel, COM-1999):**
  - Alignment: left, centre, right, full width.
  - Caption.
  - Alt text, used as the picture's text for screen readers in the Read tab, PDF and Word.
  - Size, by the corner handle (COM-1997 / COM-1998).
- A flowchart's caption shows under it the way a picture's caption does, in the Read tab, PDF and Word. Its Links stay with it. A flowchart with no caption keeps what it shows today.
- A flowchart's alt text defaults to something sensible, such as its title and step count, until someone writes their own.
- The settings that already exist on images and diagrams keep their saved values. Nothing already published changes, except that the new reading tools appear.
- Tests cover each kind having the three reading tools, each kind having alignment, caption and alt text, and a flowchart's caption and alt text reaching the PDF and Word.

Relates to:
- COM-1997 (corner handle);
- COM-1998 (flowchart sizing);
- COM-1999 (settings panel);
- COM-2003 (zoom steps).

Independent if a flowchart's caption, alignment and alt text sit on the document's flowchart block like a picture's. If the PDF/Word render needs the API to carry them, this joins the chain.