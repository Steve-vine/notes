---
id: 01M7WXC9VCC9J3DPE4C038ZR17
created: 2026-11-20T16:42:04.012498Z
updated: 2026-11-20T19:17:33.293073Z
type: task
title: Making a document's flowchart standalone takes the document's custom colours with it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2028
sprint: s6y6p7g
comments:
- id: 01M7WYW784FZMZADSMW59S8KQD
  author: Steve Vine
  at: 2026-11-20T17:08:14.212107Z
  text: |-
    Done — PR #2023, merged a93750a1.
    "Make it a standalone flowchart" on a document's own flowchart now makes it the same way Compass always does on the server. The section is saved first, so what's on screen is what gets made.
    The new standalone flowchart has the same row of custom colours as the document. The document keeps its own row, unchanged.
    Everything else is as before: a draft, owned by you, with the document's type and domain. The document keeps its own copy until the flowchart is published.
    To check on staging: set a few custom colours on a document, make its flowchart standalone, open the new flowchart and select a shape. The custom row should match the document's.
- id: 01M7X690FDN05N4WGRQC0F56BX
  author: Steve Vine
  at: 2026-11-20T19:17:33.292927Z
  text: |-
    Re-check on staging 514c4649: Passed
    All checks done as E2E Admin A in E2E Test Company, in a new document "E2E pre-UAT COM-2028 make standalone with custom colours" (Procedure) with two flowcharts of its own.
    - The new standalone flowchart gets the document's custom colour row: Passed. In the first flowchart I set Custom 1 to #8e44ad (Start's fill), Custom 2 to #e67e22 (a step's border), Custom 3 to #27ae60 (a fill) and Custom 4 to #f1c40f (a text colour), and pressed Done. The second flowchart showed the same row. Without reloading the page, I clicked the first flowchart and chose "Make it a standalone flowchart". The notice said the new flowchart is a draft and the document keeps its own copy until it's published. The new "E2E pre-UAT COM-2028 make standalone with custom colours flowchart" (draft, Procedure, owned by me) opens with the same row: purple, orange, green, yellow, then white. Its shapes keep their colours. (r4re-04, r4re-06, r4re-07, r4re-08)
    - The document keeps its own row unchanged: Passed. After the make-standalone, the document's remaining flowchart still shows purple, orange, green and yellow (r4re-09). Each row then stays separate. Setting the standalone's Custom 5 to #00ced1 left the document's Custom 5 white. Setting the document's Custom 6 to pink left the standalone's Custom 6 white.
    - Test: Passed. PR #2023 adds standaloneFromScreen.test.tsx (it saves the section, then makes the flowchart through make-standalone, never through a plain new document) and extends test_flowchart_custom_colours.py.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2028/ (r4re-*)
assignee: steve
label:
- bug
priority: medium
task_status: review
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