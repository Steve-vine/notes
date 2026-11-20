---
id: 01M7WMD99VRQSDMPTVPRPBHH0D
created: 2026-11-20T14:05:19.035001Z
updated: 2026-11-20T16:41:26.058169Z
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
- id: 01M7WXB4SA4979BP8E6ARDWBWX
  author: Steve Vine
  at: 2026-11-20T16:41:26.057932Z
  text: |-
    Pre-UAT on staging b65d7ed8 — Failed (one point: making a document's own flowchart standalone doesn't take the document's row with it; everything else passed)
    All checks were done as E2E Admin A in E2E Test Company. Documents used: "E2E pre-UAT COM-2026 Document A (custom colours)", which has two flowcharts; "…Document B, COM-2021 and COM-2025"; and the standalone "E2E pre-UAT COM-2026 standalone flowchart".
    - A second row of 9 custom swatches, all white: Passed. It sits under the house style's row (Transparent, 8 colours, Any colour) for Fill, Border, Text colour and a connection's Line colour. A lane's Header, Background and Name colour have it too. (r4-01)
    - Clicking a swatch applies it; swatch, then Any colour, sets it and applies it: Passed. I set Custom 1 to #8e44ad on Start's fill, Custom 2 to #e67e22 on a step's border, Custom 3 to #c0392b on its text, Custom 4 to #27ae60 on a connection, and Custom 5 to #f1c40f on a lane header. Clicking Custom 1 on a third step applied purple. Each took at once, and the panel said "Custom colour 1". (r4-01 to r4-03)
    - One Undo: Passed. One Undo after setting Custom 1 turned both the swatch and the shape back to white, and Redo restored both.
    - A swatch is a saved colour: Passed. I changed Custom 1 to #2980b9 while the third step was selected. That step turned blue, and Start stayed purple.
    - The same row in every flowchart of the document: Passed. I inserted a second flowchart in Document A, and its row already showed the five colours. I set Custom 6 to #ff69b4 there and pressed Done. Reopening the first flowchart showed Custom 6 pink. Cancel ("Leave without keeping") threw away a swatch I'd set. (r4-04)
    - Other documents don't see it: Passed. A flowchart in Document B had an all-white row. The standalone flowchart started all white, and setting its Custom 1 to #00ced1 didn't touch Document A's row. (r4-06)
    - Marks the document as changed: Passed. After publishing v1, I changed only Custom 7, leaving the shape the same colour, and pressed Done. The header showed "Published · draft changes". (r4-05)
    - Publish, Compare, reopen and Revert: Passed. I published v2. Compare v1 → v2 says "The custom flowchart colours changed". After a page reload, the row was still there. Reverting to v1 brought v1's row back (Custom 7 white again). (r4-07, r4-08)
    - Picture, PDF and Word: Passed. The PNG and SVG pictures, the PDF (page 2) and the Word file's pictures all show the purple, blue, orange border, red text, green line, yellow lane and pink fill. Text is light on purple and blue, and dark on pink and on the yellow header. (r4-picture.png, r4-docA-v2.pdf / -pdf-p2.png, r4-docA-v2.docx)
    - Make it a standalone flowchart takes the document's row (stated in the Done comment, not in the Done-when list): Failed. On Document A's second flowchart I used Make it a standalone flowchart. At that moment the document's row was blue, orange, red, green, yellow, pink, then white. The new standalone, "E2E pre-UAT COM-2026 Document A (custom colours) flowchart", opens with an all-white row (r4-09). Technical reason: the screen makes the new flowchart through ordinary "create content", not the "make standalone" route, and only the latter copies the row.
    - Tests: Passed. PR #2022 adds customColours.test.tsx and test_flowchart_custom_colours.py.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2026/
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