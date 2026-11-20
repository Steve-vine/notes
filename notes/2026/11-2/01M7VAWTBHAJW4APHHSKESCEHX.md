---
id: 01M7VAWTBHAJW4APHHSKESCEHX
created: 2026-11-20T01:59:47.825987Z
updated: 2026-11-20T02:36:21.021667Z
type: task
title: A flowchart pasted into another document prints straight away, without reopening it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2017
sprint: s6y6p7g
comments:
- id: 01M7VCZN5S2YJ831RMTXXDAJ4B
  author: Steve Vine
  at: 2026-11-20T02:36:17.977429Z
  text: |-
    Done — PR #2012, merged 4204c802.
    A document's own flowchart pasted from another document now has its own picture as soon as the draft saves, which happens about a second after the paste. Compass copies the first document's picture into this document. Publishing straight away prints the flowchart in the PDF and Word, and it shows on the Read tab. No one needs to reopen the Edit tab. A text diagram pasted between documents gets the same treatment.
    For every other way a flowchart can arrive without a picture (Polaris, Turn into a flowchart, an import), the Edit tab still draws the picture as it opens. Until it has, the Publish window says "A flowchart has no picture yet" and keeps Publish disabled until "Publish without it" is ticked. The message clears by itself once the picture is saved.
    Polaris's Publish refuses while a flowchart has no picture and asks the person to open the document's Edit tab first. It publishes without the picture only if the person chooses that.
    Pasting within the same document and standalone flowcharts shown in a document are unchanged.
    Assumption: publishing outside the screen and Polaris (such as the seed import) is unchanged and isn't blocked.
    To check on staging: copy a flowchart from "E2E pre-UAT COM-2006 copy and paste", paste it into "E2E pre-UAT COM-2006 paste target", publish straight away and export the PDF. It should show the flowchart, not "Not yet drawn". Separately, put a flowchart into a document through Polaris and ask Polaris to publish: it should refuse and name the Edit tab.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in the round 3 re-check, by Tester C on staging 0ed475e8, against COM-2006.

**Steps:**
1. In "E2E pre-UAT COM-2006 copy and paste", select the document's own flowchart and press Ctrl+C.
2. Open "E2E pre-UAT COM-2006 paste target" on its Edit tab and press Ctrl+V.
3. Publish straight away.
4. Export the PDF.

**Seen:** the published version 1 PDF says "Not yet drawn — open the document in Compass" where the flowchart should be. The picture is only made the next time someone opens the Edit tab, or presses Done in the flowchart editor. A copy pasted within the same document prints fine.

Evidence: ~/compass-uat/s6y6p7g/COM-2006/r3re-target-published-v1.pdf, r3re-target-draft.pdf and r3re-target-draft-after-reopen.pdf

**Done when**
- A flowchart pasted from one document into another has its finished picture saved for the target document as part of the paste, or before the draft is saved. Publishing straight away then prints it in the PDF and Word, and shows it on the Read tab.
- The same holds for every other way a flowchart can arrive in a document without its own saved picture: paste, Polaris, import, Turn into a flowchart. If anything could still publish without a picture, the PDF says so clearly and no one can publish it silently. The safest route is to make the picture before publishing.
- Within-document paste and standalone references are unchanged.
- Tests cover a cross-document paste followed by an immediate publish, with the PDF containing the flowchart picture.

Independent, unless the server has to make the picture. If so, it joins the chain.