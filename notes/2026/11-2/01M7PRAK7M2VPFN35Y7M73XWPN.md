---
id: 01M7PRAK7M2VPFN35Y7M73XWPN
created: 2026-11-18T07:18:18.612096Z
updated: 2026-11-18T07:27:40.090784Z
type: task
title: Browser smoke journey 6 picks the right "Flowchart…" in the Insert menu
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1928
sprint: s6y6p7g
comments:
- id: 01M7PRVPXDZ3FP6S6AB452EWC2
  author: Steve Vine
  at: 2026-11-18T07:27:39.43714Z
  text: |-
    Done — PR #1913, merged 82553eed.
    Browser smoke journey 6 now picks the exact "Flowchart…" item in the Insert menu, now that "An existing flowchart…" (COM-1908) sits beside it. It's a test change only: the app was right.
    To check on staging: nothing for Steve. The Browser smoke is being re-run on staging (run 44259003045).
assignee: steve
label:
- bug
priority: high
task_status: review
---
Staging deploy of faf46f33 (2026-11-18 07:17 GMT): the Browser smoke was 34/35. Journey 6 ("draft a policy … draw a flowchart") failed because the Insert menu now has both "Flowchart…" (COM-1904) and "An existing flowchart…" (COM-1908), and the test's "Flowchart…" lookup matched both. The app is right, so this is a test fix only.

**Done when**
- Journey 6 picks the exact "Flowchart…" item, and the Browser smoke is green on staging.

Independent: test only, no app change.