---
id: 01M7WMD99VRQSDMPTVPRPBHH0D
created: 2026-11-20T14:05:19.035001Z
updated: 2026-11-20T14:48:05.875465Z
type: task
title: A row of custom colours under the flowchart colour palette, kept with the document
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2026
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: active
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