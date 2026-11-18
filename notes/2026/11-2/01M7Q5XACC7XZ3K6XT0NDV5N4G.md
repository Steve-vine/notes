---
id: 01M7Q5XACC7XZ3K6XT0NDV5N4G
created: 2026-11-18T11:15:43.628697Z
updated: 2026-11-18T11:39:51.509746Z
type: task
title: A flowchart's section heading stays on the same PDF and Word page as its picture
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1938
sprint: s6y6p7g
comments:
- id: 01M7Q79FHA0VVS7865V525ZNBQ
  author: Steve Vine
  at: 2026-11-18T11:39:50.698455Z
  text: |-
    Done — PR #1932, merged c15afb4d.
    A flowchart straight after a heading is now fitted to the page with room kept for that heading. The two always fit one page together, so the heading moves to the next page with the picture rather than being left alone at the foot of the page before. The caption stays with them as before.
    In Word, headings now keep with the paragraph that follows, and the picture leaves room for its heading.
    Tests export a tall flowchart under a heading: in the PDF the heading, every step and the caption are on one page; in Word the heading keeps with the picture. The PDF test fails without the fix.
    To check on staging: re-export "E2E pre-UAT COM-1931 text diagram conversion"; "1 Fixing a fault" should sit above its flowchart on the same page.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Re-check 2 on staging a182f6be, 2026-11-18 (tester A, after COM-1936): "E2E pre-UAT COM-1931 text diagram conversion (draft)" (v3) exports a PDF where page 2 holds only the heading "1 Fixing a fault" and is otherwise blank. The flowchart and its caption are on page 3.
Files: ~/compass-uat/s6y6p7g/COM-1936/re2-knownfix-p2-p3.png, re2-knownfix.pdf

**Done when**
- A heading directly before a flowchart moves to the next page with the picture when the picture doesn't fit under it, in PDF and Word. A page never ends with a lone heading.
- The flowchart's caption stays with it, as COM-1936 already does.
- A test exports a tall flowchart under a heading and checks the heading and picture are on the same page.

Independent.