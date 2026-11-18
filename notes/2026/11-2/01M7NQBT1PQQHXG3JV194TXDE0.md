---
id: 01M7NQBT1PQQHXG3JV194TXDE0
created: 2026-11-17T21:42:15.35079Z
updated: 2026-11-18T11:15:20.120868Z
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
- id: 01M7PVFZCRAHNSH3XVTSE4ZAKR
  author: Steve Vine
  at: 2026-11-18T08:13:40.632206Z
  text: |-
    Pre-UAT on staging faf46f33 — Failed
    Document used: "E2E pre-UAT COM-1904 flowchart document" (Procedure, published v1–v3), as E2E Admin A in E2E Test Company.
    - Add, edit and remove a flowchart, every shape, labelled connections, Tidy up: Failed (two defects, below). Insert ▸ Flowchart opened the full-screen canvas. I drew all seven shapes (Start/End, Step with a description, Decision, Document, Input/Output, Hand-off, Note). I joined shapes by dragging between them and labelled the Decision's two connections Yes and No. The following all worked: Tidy up both ways, grid snapping, hand placement, Undo/Redo, Shift-click to select several then Delete, copy/paste, the arrow keys on a freshly opened canvas, zoom and Fit, and Done. Done puts in a picture with its caption, and clicking it reopens the canvas. Remove takes the flowchart out of the document.
      DEFECT 1 (keyboard): once you've added any shape in a canvas session, clicking a shape puts the cursor in the side panel's Label box. After that, Delete, Tab, the arrow keys and Ctrl+C no longer act on the shape. Backspace deletes the last letter of its label ("End" became "En"). The arrow keys move one shape and then stop. On a canvas just opened, with nothing added yet, the same keys work. Screenshot 03-backspace-edits-label.png.
      DEFECT 2 (Tidy up): when a branch joins back into the flow, Tidy up puts every step in one row or column and draws the "No" connection behind four shapes (04-tidy-top-bottom.png, 05-tidy-left-right.png). In my test a Hand-off connected to End came out after End. In v2 "Approved?" came out before "Check the request is complete", the step that leads into it (16-v2-chart.png). The plain text still numbers the steps in the right order. A branch that doesn't rejoin tidies up neatly (06-tidy-branch.png).
    - Published document shows it, and PDF, Word and plain text include it: Passed. The Read tab shows the picture with zoom, full screen and Download. The PDF and Word file each show the picture with its caption (v1.pdf, v1.docx). The plain text gives the steps in order: "3. Approved? Yes → 4; No → 8", "8. Hand off: …", "Note: …".
    - Compare versions reports a changed flowchart in words: Passed. Comparing v1 to v2 lists lanes added, steps that moved lane, links added, "Step reworded: Send the confirmation → Email the confirmation", "Step added", connections added and removed, and "Now laid out left to right" (17-compare.png).
    - Reading view at phone width (390px), no sideways page scroll: Passed. The page stays at 390px wide, zoomed or not, with "Show as on paper" both on and off. The flowchart pans inside its own frame, and full screen works (09–14).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1904/
- id: 01M7Q27E6GQVZFWVQ19YRBRPD9
  author: Steve Vine
  at: 2026-11-18T10:11:20.912246Z
  text: |-
    Re-check on staging 27151cd9:
    - Defect 1 (keyboard) now Passed (COM-1933). After adding shapes, clicking a shape keeps the keyboard on the canvas. Delete, Backspace, Tab, the arrows and Ctrl+C/V act on the shape every time, and Escape takes you out of the Label box.
    - Defect 2 (Tidy up) partly fixed, still Failed. With the Hand-off joined to End again, Tidy up now keeps flow order and no line runs through a step. But the Hand-off → End line and the Write up → Email line share the arrowhead into "Email the confirmation", on the canvas and in the PDF, so the Hand-off still appears to lead to Email. Logged under COM-1931 (~/compass-uat/s6y6p7g/COM-1931/re-01-tidy-LR.png, re-v4-p4-hi.png).
- id: 01M7Q5WKDRCQ5GH2M77VKT05C3
  author: Steve Vine
  at: 2026-11-18T11:15:20.117578Z
  text: |-
    Re-check on staging a182f6be: the Tidy up and layout point is now Passed.
    - The request flow, with the Hand-off joined to End, tidies in flow order.
    - No line goes through a step.
    - The Hand-off goes down to End on its own line, and only "Write up the change" leads into "Email the confirmation", on the canvas and in the PDF (COM-1935).
    - With the keyboard point already passed, everything I raised on COM-1904 now passes.
    Files: ~/compass-uat/s6y6p7g/COM-1935/re2-03-request-flow-canvas.png, re2-request-p4.png
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