---
id: 01M7WXC9VCC9J3DPE4C038ZR17
created: 2026-11-20T16:42:04.012498Z
updated: 2026-11-20T16:42:04.012498Z
type: task
title: Making a document's flowchart standalone takes the document's custom colours with it
task_status: todo
priority: medium
assignee: steve
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2028
---
Found in Claude's pre-UAT of COM-2026 (staging b65d7ed8, tester A).

COM-2026 promises that when a document's own flowchart is made standalone, it takes the document's custom colour row with it. It doesn't: the new standalone flowchart's custom row is all white.

**Steps:**
1. Open a document whose flowcharts have custom colours set.
2. On the Edit tab, click its own flowchart and choose "Make it a standalone flowchart".
3. Open the new standalone flowchart and select a shape.

**Seen:** the custom row is all white. Screenshot: ~/compass-uat/s6y6p7g/COM-2026/r4-09-made-standalone-row.png

**Technical:** the screen makes the standalone through ordinary create-content (`app/frontend/src/content/flowchart/standalone.ts`). Only the backend make-standalone route (`flowchart_refs.make_standalone`) copies the row, and the screen never calls it.

**Done when**
- "Make it a standalone flowchart" from the screen gives the new standalone flowchart the same custom colour row as the document.
- The document keeps its own row unchanged.
- A test covers making a flowchart standalone from the screen, with custom colours set.