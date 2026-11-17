---
id: 01M7NQBT1PQQHXG3JV194TXDE0
created: 2026-11-17T21:42:15.35079Z
updated: 2026-11-17T21:42:15.35079Z
type: task
title: 'A flowchart in a document: draw one on a canvas, published and reviewed with its document'
assignee: steve
label: feature
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1904
---
The first piece of the flowchart sprint: a document's own flowchart, and the canvas every later task reuses. Built to COM-1903 (ADR 0160).

**What the author sees**
- In a document's editor, **Insert ▸ Flowchart** adds a flowchart and opens it on a canvas, full screen, alongside the existing Image, Drawing and Text diagram.
- **Shapes:** Start/End, Step, Decision, Document, Input/Output, Hand-off (to another flow, outside this one) and Note (a comment that isn't a step). Each has a label, and a step can also have a short description.
- **Connections:** drag from one shape to another. A connection can have a label, and a Decision's connections offer **Yes** / **No** (or any wording). Connections follow shapes as they move.
- **Tidy layout:** **Tidy up** lays the flow out top to bottom or left to right, and new shapes snap to a grid. A person can still place shapes by hand, and Compass remembers where.
- Undo/redo, select several, copy/paste, delete, zoom and fit to screen. The keyboard can add a step after the selected one and move between shapes.
- **Done** returns to the document, where the flowchart sits as a picture with an optional caption. Clicking it in the editor reopens the canvas.
- Shapes use the house style's colours in light and dark, as text diagrams do.

**What a reader sees**
- The document shows the flowchart as a picture that can be zoomed and panned, and opened full screen. At phone width it fits the width and can be panned, never pushing the page sideways.
- The PDF and Word exports show it as a picture. The plain-text export, search and Polaris read it as its steps in order: "1. Receive the request → 2. Approved? Yes → 3 … No → 5".

**Publishing and reviews**
- The flowchart is part of the document. Changing it is a change to the draft, it's published with the document, and the document's reviews cover it. Compare versions shows that the flowchart changed and lists the steps added, removed or reworded.
- A flowchart nobody has drawn yet (e.g. one Polaris wrote, or one from an import) shows "Not yet drawn — open the document in Compass" in PDF and Word, as text diagrams do today.

**Done when**
- An author can add, edit and remove a flowchart in a templated document, with every shape above, labelled connections and Tidy up.
- A published document shows it, and its PDF, Word and plain-text exports include it.
- Compare versions reports a changed flowchart in words.
- Reading view works at phone width with no sideways page scroll.

On the chain: the document format gains a flowchart block, which the server checks and stores.