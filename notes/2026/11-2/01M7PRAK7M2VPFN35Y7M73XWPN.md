---
id: 01M7PRAK7M2VPFN35Y7M73XWPN
created: 2026-11-18T07:18:18.612096Z
updated: 2026-11-18T07:18:28.122996Z
type: task
title: Browser smoke journey 6 picks the right "Flowchart…" in the Insert menu
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1928
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Staging deploy of faf46f33 (2026-11-18 07:17 GMT): the Browser smoke was 34/35. Journey 6 ("draft a policy … draw a flowchart") failed because the Insert menu now has both "Flowchart…" (COM-1904) and "An existing flowchart…" (COM-1908), and the test's "Flowchart…" lookup matched both. The app is right, so this is a test fix only.

**Done when**
- Journey 6 picks the exact "Flowchart…" item, and the Browser smoke is green on staging.

Independent: test only, no app change.