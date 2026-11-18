---
id: 01M7Q5XACC7XZ3K6XT0NDV5N4G
created: 2026-11-18T11:15:43.628697Z
updated: 2026-11-18T12:06:18.58982Z
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
- id: 01M7Q8SY6X10X5EZKFY8Q9JF6S
  author: Steve Vine
  at: 2026-11-18T12:06:18.589599Z
  text: |-
    Pre-UAT on staging c15afb4d — Passed
    As E2E Admin A, I re-exported "E2E pre-UAT COM-1931 text diagram conversion (draft)" (v3) as PDF and Word.
    - A heading right before a flowchart moves with the picture, and a page never ends with a lone heading: Passed.
      - The PDF is now 2 pages. Page 2 has "1 Fixing a fault", the whole 8-step flowchart down to "Close the incident", and the caption, with the footer clear (re3-knownfix-p2.png, re3-knownfix.pdf). No page holds only a heading; before the fix, page 2 had only the heading.
      - In the Word file, the heading and the picture are both set to keep with the next paragraph. The picture is 2.83 × 8.35 inches, which leaves room for the heading on the page (re3-knownfix.docx). I didn't open it in Word itself.
    - The caption stays with the flowchart: Passed. It's on page 2 under the picture in the PDF, and straight after it in Word.
    - Nothing else moved: the COM-1904 document's PDF (v5) has the same 10 pages as before. Its landscape pages 3–5 and 7–9, its portrait pages 2, 6 and 10, the 2-part and 6-part splits and the Links list are all where they were (re3-main.pdf).
    - Tests: not checked in the browser.
    Files: ~/compass-uat/s6y6p7g/COM-1938/
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