---
id: 01M7WMD99VRQSDMPTVPRPBHH0D
created: 2026-11-20T14:05:19.035001Z
updated: 2026-11-20T16:04:38.310666Z
type: task
title: A row of custom colours under the flowchart colour palette, kept with the document
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2026
sprint: s6y6p7g
comments:
- id: 01M7WV7NMDTXNV8KBZA2PZE450
  author: Steve Vine
  at: 2026-11-20T16:04:35.085128Z
  text: |-
    Done — PR #2022, merged b65d7ed8.
    - The flowchart colour palette now has a second row of 9 custom swatches under the house style's, all white to begin with.
    - Clicking a custom swatch applies it to the selection. To set one, click it, then Any colour, and pick a colour or type a hex code: the swatch takes that colour and it's applied. One Undo takes both back.
    - The custom row appears under Fill, Border, Text colour and a connection's or Line's colour, and also under a lane's Header, Background and Name colour.
    - The row belongs to the document, and every flowchart in it shows the same row. A standalone flowchart keeps its own row, and other documents don't see it. Making a document's own flowchart standalone takes the document's row with it.
    - Setting a custom colour shows the document as having unpublished changes. Publishing keeps the row with that version, Revert brings a version's row back, and Compare versions says "The custom flowchart colours changed".
    - A swatch is a saved colour. Shapes keep the colour they were given if the swatch changes later. Custom colours stay as they are in the picture, PDF and Word, whatever the house style, and text on them turns light or dark automatically as before.
    Assumptions:
    - Custom colours are saved with the flowchart when you press Done, like everything else on the canvas. Cancel throws them away.
    - Lanes get the custom row too, because they use the same colour picker.
    To check on staging (migration 0884 runs on deploy):
    - In a document, set a custom colour on one flowchart and press Done. The document should show unpublished changes.
    - Open another flowchart in the same document: the colour is in its row.
    - Open a different document: its row is still white.
    - Publish, then reopen the first document: the row is kept.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve (testing round 3): the flowchart colour palette shows 9 colours, Transparent included. Add a second row below it where a person can set their own colours.

How it works:
- The custom swatches all start white.
- A person clicks one, then clicks the "any colour" icon and picks a colour. That swatch becomes the chosen colour.
- From then on the custom colour can be picked for Fill, Border or Text, on this document only.

**Done when**
- The palette has a second row of custom swatches under the first. Assumption: the same number as the first row (9), all starting white.
- Clicking a custom swatch applies it to the selection, as the first row does. Clicking one and then choosing a colour with "any colour" sets that swatch to the colour and applies it.
- Custom colours are offered for Fill, Border and Text. Assumption: also for a connection's line colour, since it uses the same palette.
- Custom colours are kept with the document. Every flowchart in that document sees the same custom row. A standalone flowchart keeps its own. Other documents don't see them.
- Changing a custom swatch later doesn't recolour shapes that already use the old colour. Assumption: the swatch is a saved colour, not a link.
- Setting a custom colour marks the document as changed and is one Undo step.
- Custom colours look right in the picture, PDF and Word, and text on a custom fill stays readable (it turns light or dark automatically, as now).
- Tests cover setting a custom colour, using it for fill, border and text, and reopening the document.