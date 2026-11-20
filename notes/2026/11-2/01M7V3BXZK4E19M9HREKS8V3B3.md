---
id: 01M7V3BXZK4E19M9HREKS8V3B3
created: 2026-11-19T23:48:14.45145Z
updated: 2026-11-20T00:10:08.321941Z
type: task
title: Copying, cutting and pasting a flowchart in a document keeps it a flowchart
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2006
sprint: s6y6p7g
comments:
- id: 01M7V4KXG1RQQX5HQP7WH2E0JZ
  author: Steve Vine
  at: 2026-11-20T00:10:04.673035Z
  text: |-
    Done — PR #2001, merged c9b7755e.
    A document's own flowchart, copied and pasted with Ctrl+C / Ctrl+V, now pastes as a flowchart rather than a plain picture. It has the same shapes, connections, lanes, caption, alt text, size and alignment, and double-click opens it in the flowchart editor. This works in the same section, in another section, or in another document.
    The copy belongs to the author. The flowchart travels inside the block, so changing the copy never changes the original. If the original is being made into a standalone flowchart, the copy doesn't carry that across, so the two never become the same saved flowchart when it's published.
    Cut and paste moves the flowchart with nothing lost, including a standalone flowchart in the making. Paste it a second time and the second one is a copy.
    A standalone flowchart shown in a document pastes as another view of the same flowchart and version, now keeping its size and alignment. A text diagram's size and alignment also survive a paste now.
    Pasting outside Compass still gives the picture and its caption, as before.
    Assumption: cut and paste are two separate actions. Undo after the paste takes the paste back in one step, and a second Undo puts the cut flowchart back.
    Assumption: a flowchart cut in one browser tab and pasted in another counts as a copy. It loses only the "being made standalone" mark.
    To check on staging: on the Edit tab, click a flowchart, copy it and paste it lower down. The panel should say Flowchart, not Picture. Double-click the copy, change it, and confirm the original is unchanged. Then cut a flowchart, paste it elsewhere and use Undo.
assignee: steve
label:
- bug
priority: high
task_status: review
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