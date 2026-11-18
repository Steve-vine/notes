---
id: 01M7Q5XACC7XZ3K6XT0NDV5N4G
created: 2026-11-18T11:15:43.628697Z
updated: 2026-11-18T11:16:01.296072Z
type: task
title: A flowchart's section heading stays on the same PDF and Word page as its picture
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1938
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Re-check 2 on staging a182f6be, 2026-11-18 (tester A, after COM-1936): "E2E pre-UAT COM-1931 text diagram conversion (draft)" (v3) exports a PDF where page 2 holds only the heading "1 Fixing a fault" and is otherwise blank. The flowchart and its caption are on page 3.
Files: ~/compass-uat/s6y6p7g/COM-1936/re2-knownfix-p2-p3.png, re2-knownfix.pdf

**Done when**
- A heading directly before a flowchart moves to the next page with the picture when the picture doesn't fit under it, in PDF and Word. A page never ends with a lone heading.
- The flowchart's caption stays with it, as COM-1936 already does.
- A test exports a tall flowchart under a heading and checks the heading and picture are on the same page.

Independent.