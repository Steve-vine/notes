---
id: 01M7V3BXZK4E19M9HREKS8V3B3
created: 2026-11-19T23:48:14.45145Z
updated: 2026-11-20T14:05:05.215232Z
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
- id: 01M7VAT8T71BB5AS09FNJ6ZZAZ
  author: Steve Vine
  at: 2026-11-20T01:58:24.327465Z
  text: |-
    Pre-UAT on staging 0ed475e8 — Failed (one point: pasting into another document)
    Tested as E2E Admin A in E2E Test Company, headless Chromium, with the browser's own clipboard. Test documents: "E2E pre-UAT COM-2006 copy and paste" (a document's own two-lane flowchart at 60%, Right, with a caption and alt text, plus a standalone shown at 50%, Left) and "E2E pre-UAT COM-2006 paste target".
    - A document's own flowchart pastes as a flowchart in the same document: Passed. I selected it, pressed Ctrl+C, and pasted further down with Ctrl+V. The copy's panel says Flowchart (Edit flowchart, Make it a standalone flowchart). It has the same lanes (Asker/Helper), 4 steps and 3 connections, 408 px wide (60%), aligned Right, with the caption "Laned copy me" and the alt text "E2E alt for copy me". Double-click opens it in the flowchart editor.
    - The copy is independent, with its own identity: Passed. I renamed a lane in the copy to "Asker copy" and pressed Done. The original kept "Asker" and its own picture. The copy got a new picture of its own. Editing one of three copies that shared a picture also gave only that one a new picture; the other two were unchanged.
    - Cut and paste moves it with nothing lost: Passed. Ctrl+X, then Ctrl+V lower down: it moved with the same lanes, steps, connections, size, alignment, caption, alt text and picture, and double-click still opens it. On Undo: the first Ctrl+Z takes the paste back and the second puts the cut flowchart back, as the builder's stated assumption says. The Done-when said "as one Undo step": Steve to confirm two steps is acceptable. Redo ×2 restores the move.
    - A standalone shown in a document pastes as another view of the same flowchart: Passed. The saved text has two identical references to the same standalone, version 1, both at 50% and Left. The pasted one's panel offers Edit flowchart.
    - Pasting into another document behaves the same way: FAILED, for the picture. In the target document, the pasted flowchart shows, edits and saves correctly in the editor, and a standalone pasted there is the same reference. But a document's own flowchart pasted from another document arrives with no saved picture, unlike a copy in the same document. Its PDF then says "Not yet drawn — open the document in Compass". I pasted it and published straight away: version 1's PDF has "Not yet drawn" in place of the flowchart (r3re-target-published-v1.pdf). The picture is only made the next time someone opens the document's Edit tab, or presses Done in the flowchart editor. After a reload of the Edit tab, the draft's PDF showed it.
    - Pasting into a plain text field, or outside Compass, gives a sensible picture or text, as today: Passed, as today. Pasting into the tags box gives nothing, the same as copying a plain picture does today: both put empty plain text on the clipboard. The HTML copy holds the picture (img) and its caption. A standalone's HTML copy carries no picture (unchanged).
    - Tests: in the PR; not re-run here.
    Observation: after a paste, the pasted flowchart stays selected, so a second Ctrl+V straight away replaces it rather than adding another; click elsewhere first. That's the editor's usual rule for a selected item; I didn't compare it with a picture.
    Steve: copy a flowchart from one document, paste it into another and publish without reloading. The published PDF says "Not yet drawn".
    Screenshots and PDFs: ~/compass-uat/s6y6p7g/COM-2006/ (r3re-*)
- id: 01M7VEW7CFHZJ4B6YG0EHMHP8A
  author: Steve Vine
  at: 2026-11-20T03:09:22.702881Z
  text: |-
    Re-check on staging 85a42994: pasting into another document now Passed (fixed by COM-2017)
    - As E2E Admin A, I copied the document's own flowchart from "E2E pre-UAT COM-2006 copy and paste" and pasted it into a new draft, "E2E pre-UAT COM-2017 paste target". The flowchart was saved with a picture of its own about 1 s later. I published straight away without reloading.
    - Version 1's Read tab, PDF and Word all show the flowchart, and none of them says "Not yet drawn".
    - A standalone flowchart pasted across documents is still the same reference: version 1, 50%, Left.
    Files: ~/compass-uat/s6y6p7g/COM-2017/r3fin-published-v1.pdf and .docx
assignee: steve
label:
- bug
priority: high
task_status: done
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