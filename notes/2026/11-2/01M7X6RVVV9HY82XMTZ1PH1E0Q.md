---
id: 01M7X6RVVV9HY82XMTZ1PH1E0Q
created: 2026-11-20T19:26:12.859162Z
updated: 2026-11-20T22:18:40.352511Z
type: task
title: Printing a content page from the browser prints the document, not a blank page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2037
sprint: s9hexqn
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found by Claude's pre-UAT tester during sprint 118 round 4 checks (staging 514c4649). It isn't caused by the flowchart work. It looks like it comes from the Library reader (sprint 119).

**Steps:** open any content page (Read tab) and print it from the browser (Ctrl+P).

**Expected:** the document prints. **Seen:** an empty page.

The Library reader prints correctly, and Compass's own Print preview / PDF export is unaffected.

**Technical:** the Library reader's print rule ("hide everything except `.library-reader`") is in the app's main stylesheet. So on every other page, the app root is hidden when printing.

**Evidence:**
- ~/compass-uat/s6y6p7g/COM-2034/r4re-browser-print-content-page.pdf (blank)
- ~/compass-uat/s6y6p7g/COM-2034/r4re-browser-print-library-reader.pdf (correct)

**Done when**
- Printing a content page from the browser prints its contents, on both the Read and Edit tabs.
- The Library reader still prints only the document, as now.
- Other screens print as they did before the Library reader.
- A test covers print styles on a content page and in the Library reader.