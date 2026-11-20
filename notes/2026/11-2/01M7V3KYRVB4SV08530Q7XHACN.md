---
id: 01M7V3KYRVB4SV08530Q7XHACN
created: 2026-11-19T23:52:37.403216Z
updated: 2026-11-20T00:06:00.347999Z
type: task
title: Pictures' alt text reaches the PDF, and a standalone flowchart's alt text is the same everywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2010
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in pre-UAT of round 3, by Tester B on staging 7ea67f64, against COM-2004.

**Steps:** give a flowchart, a drawing and a diagram their own alt text, then export the PDF and Word.

**Seen:**
- Word has the alt text for every picture.
- The PDF has none: it is untagged, with no structure tree and no /Alt, and the alt strings appear nowhere in it. The test only checks the HTML that becomes the PDF. File: ~/compass-uat/s6y6p7g/COM-2004/r3-export3.pdf
- A standalone flowchart shown in a document reads "Flowchart, 4 steps" on the Read tab, with no title, but "Flowchart: <title>, version 5, 4 steps" in Word.

**Done when**
- In the PDF, every picture (image, drawing, text diagram, flowchart) carries its alt text where a screen reader finds it, as /Alt on a tagged figure. Check it with a PDF reader or python. Pictures with no alt text are handled the way the PDF tools expect, either as decorative or with their default.
- Tagging the PDF doesn't change how it looks: the same pages, fonts, page breaks and house style. Check one long document before and after.
- A standalone flowchart's default alt text is the same on the Read tab, in the PDF and in Word.
- PDFs already cached for published documents are made afresh, if the cache needs a version bump.
- Tests check the actual PDF, not just the HTML: /Alt present for each kind.

If the PDF engine can't tag pictures without a large change, say so in the PR and the task comment, and do the smallest reliable version. Don't drop it silently.

Independent: backend PDF render (core/render).