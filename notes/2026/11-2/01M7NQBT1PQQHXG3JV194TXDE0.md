---
id: 01M7NQBT1PQQHXG3JV194TXDE0
created: 2026-11-17T21:42:15.35079Z
updated: 2026-11-18T03:50:32.308092Z
type: task
title: 'A flowchart in a document: draw one on a canvas, published and reviewed with its document'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1904
sprint: s6y6p7g
blocked_by:
- 01M7NQBDG6KKFQ8NCG5HT61XJC
comments:
- id: 01M7PCDZ7D6Q5NHPE28D9J5JY8
  author: Steve Vine
  at: 2026-11-18T03:50:26.285731Z
  text: |-
    Done — PR #1902, merged f2268b4f.
    In a document's editor, Insert ▸ Flowchart opens a full-screen canvas: Start/End, Step, Decision, Document, Input/Output, Hand-off and Note shapes, connections dragged between them (a Decision's offer Yes / No), Tidy up (top to bottom or left to right), a snapping grid, undo/redo, select several, copy/paste, and keyboard moves (Tab adds a step after the selected one; the arrows move between shapes).
    Done puts it in the section as a picture with a caption; clicking it reopens the canvas.
    Readers see the picture fitted to the page, with zoom in/out and full screen; at phone width it fits and pans inside its own frame, never pushing the page sideways.
    PDF and Word show the picture; the plain-text export, Polaris and search read it as its steps in order ("2. Approved? Yes → 3; No → 5"). One not yet drawn shows "Not yet drawn — open the document in Compass" with its steps.
    Compare versions now lists "Flowchart changes" in words (steps added, removed, reworded, connections, layout).
    Assumption: steps are numbered by following the flow from its start, branches in the order the picture shows them (left to right).
    To check on staging: draw one in a test document, publish, and open its PDF and Word — the picture is saved by the browser the first time the flowchart is shown in the editor.
assignee: steve
label:
- feature
priority: medium
task_status: review
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