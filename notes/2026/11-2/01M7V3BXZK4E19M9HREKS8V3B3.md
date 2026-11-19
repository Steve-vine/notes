---
id: 01M7V3BXZK4E19M9HREKS8V3B3
created: 2026-11-19T23:48:14.45145Z
updated: 2026-11-19T23:48:20.256058Z
type: task
title: Copying, cutting and pasting a flowchart in a document keeps it a flowchart
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2006
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in pre-UAT of round 3, by Tester C on staging 7ea67f64, against COM-2001.

**Steps:** on a document's Edit tab, click a flowchart once to select it. Press Ctrl+C, put the cursor elsewhere and press Ctrl+V. Then try Ctrl+X followed by Ctrl+V.

**Seen:** the pasted item is a plain picture. It opens the "Picture" settings panel, and double-click doesn't open the flowchart editor. Cut and paste therefore loses the flowchart altogether.

Screenshot: ~/compass-uat/s6y6p7g/COM-2001/r3-08-pasted-is-an-image.png. The draft of "E2E pre-UAT COM-2001 select a flowchart" holds the two pasted pictures.

**Done when**
- A document's own flowchart, copied and pasted within the same document, pastes as a flowchart. It has the same shapes, connections, lanes, size, alignment, caption and alt text, and can be edited by double-click.
- The copy is independent: editing it doesn't change the original. It gets its own identity, so the two never share one saved flowchart.
- Cut and paste moves the flowchart, with nothing lost, as one Undo step.
- A standalone flowchart shown in a document pastes as another reference to the same standalone flowchart.
- Pasting into another document behaves the same way.
- Pasting copied flowchart content into a plain text field, or outside Compass, still gives a sensible picture or text, as today.
- Tests cover copy-paste and cut-paste of a document's own flowchart and of a standalone reference.

Independent, unless pasting a document's own flowchart needs the server to copy its saved flowchart. If it does, it joins the chain.