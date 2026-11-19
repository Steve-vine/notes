---
id: 01M7QEK9RR3JMXQTTGJQRHGHZH
created: 2026-11-18T13:47:32.504105Z
updated: 2026-11-19T18:45:29.405764Z
type: task
title: A flowchart always fits on one page in PDF and Word, scaled down rather than split
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1960
sprint: s6y6p7g
comments:
- id: 01M7QMZ5EN8VTP48YHEK643RR2
  author: Steve Vine
  at: 2026-11-18T15:38:52.757373Z
  text: |-
    Done — PR #1937, merged ae049b50.
    Every flowchart in a PDF or Word file now sits whole on one page. It's shrunk evenly to fit the width and height left on the page it's on, portrait or landscape. That covers a document's own flowchart, a standalone one shown in a document, and a standalone flowchart's own export. "Part n of N" is gone.
    A small flowchart is never blown up past its own size. One that won't fit under the text above it moves to the top of the next page. Its heading, caption and Links list stay on the same page as the picture.
    The "Wide flowchart: put it on a landscape page?" hint still appears. It now shows when the flowchart would be shrunk a lot on a portrait page and a landscape page would show it bigger. So a tall flowchart, which a landscape page would only make smaller, doesn't get the hint.
    ADR 0160 §6 has a dated note recording the change.
    Assumptions: a very long Links list takes at most about a third of the page; anything beyond that carries over to the next page rather than squeezing the picture. "Shrunk a lot" means below 70%, the old threshold.
    To check on staging: re-download the PDF and Word file of the 26-shape flowchart and of the wide request flow on its landscape page. Each should be on one page. Cached PDFs are redrawn because the renderer version was bumped.
- id: 01M7R71G0HKW68KTRZEC6RRWEA
  author: Steve Vine
  at: 2026-11-18T20:54:43.473279Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Passed
    As E2E Admin A in E2E Test Company. I fetched fresh PDF and Word files and checked them with pypdf/python-docx plus page renders.
    - No flowchart split, in PDF or Word: Passed. Across every file below, "Part n of N" appears nowhere.
    - The pre-UAT examples each on one page: Passed.
      - "E2E pre-UAT COM-1904 flowchart document": the 26-shape very large flow is whole on landscape page 5 (it was 6 parts in round 1), and the request flow is whole on landscape page 3 with its caption and Links list on the same page. In Word, both pictures fit their landscape sections (814×293pt and 814×49pt within 814×462pt usable) (r2-com1904-doc-p3.png, -p5.png).
      - The COM-1931 tall Known-fix flow and the COM-1936 password-reset flow: each whole on one portrait page with heading and caption (r2-com1931-doc-p2.png).
    - Scaled to the page with proportions kept; heading, caption and Links stay with it; moves to the next page when it won't fit: Passed. "E2E pre-UAT COM-1960 fit to page" has 14 paragraphs, then a tall standalone flowchart, then a line of text. The PDF ends page 2 after paragraph 14 and puts the whole flowchart, its caption and the following text on page 3 (r2-fit-doc-v4-p2.png, -p3.png). In Word the picture is 567×580pt in a 567×709pt usable page, and the picture and caption carry keep-with-next.
    - Standalone flowcharts' own PDF and Word: Passed. Each of my three is one portrait page.
    - A small flowchart is never blown up: Passed. The 3-shape Lucidchart import is 338px wide and comes out at 253pt (338 × 0.75) in Word and PDF, not page width (r2-small-flowchart.pdf/.docx).
    Observation: in the COM-1904 document, the section heading ("2 A very large flowchart") stays on the portrait page before the Landscape page that holds the flowchart. That's because the author's Landscape page break sits between them, so it isn't this task's doing.
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-1960/
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve, testing on staging, 2026-11-18: flowcharts aren't being resized to fit the page. A single flowchart placed in a document should always be resized to fit on a page rather than split between two.

**This replaces an earlier rule.** COM-1910, 1932 and 1936 split a flowchart into "Part n of N" pages when, shown whole, its text would fall below a readable minimum (70% of canvas size). Steve's decision: never split. Fit it to one page.

**What a reader sees in the PDF and Word file**
- **One page:** every flowchart (a document's own, a standalone one shown in a document, or a standalone flowchart's own export) is scaled to fit on one page: the page it's on, portrait or landscape. It's never cut into parts, and nothing runs off the page.
- **Fitting:** it's scaled down evenly, keeping its proportions, to the width and height left on that page. If it doesn't fit in the space left under the text above it, it moves to the top of the next page and is fitted there. Its heading moves with it (COM-1938), and its caption and Links list follow it.
- **Never bigger:** a small flowchart is never blown up beyond its own size.
- **On screen:** the reading view is unchanged. It still zooms and pans.

**What the author sees**
- The "Wide flowchart: put it on a landscape page?" hint (COM-1910) stays. It now appears when a flowchart would be shrunk a lot on a portrait page, because a landscape page would show it bigger. Yes and Dismiss work as before.
- Nothing else changes in the editor.

**Done when**
- No flowchart is ever split across pages, in PDF or Word.
- Every flowchart sits whole on one page, scaled to fit the page it's on with its proportions kept, and with its heading, caption and Links list beside it.
- The examples from pre-UAT each come out on one page: the 26-shape flowchart and the wide request flow on its landscape page.
- Tests cover a very wide flow, a very tall flow and a small flow (not enlarged), in PDF and Word. The old "Part n of N" tests are replaced.

Independent: backend render (and the editor hint's threshold).