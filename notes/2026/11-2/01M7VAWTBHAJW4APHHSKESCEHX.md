---
id: 01M7VAWTBHAJW4APHHSKESCEHX
created: 2026-11-20T01:59:47.825987Z
updated: 2026-11-20T01:59:53.896987Z
type: task
title: A flowchart pasted into another document prints straight away, without reopening it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2017
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
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