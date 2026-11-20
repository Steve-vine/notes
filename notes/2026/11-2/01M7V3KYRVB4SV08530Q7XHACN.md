---
id: 01M7V3KYRVB4SV08530Q7XHACN
created: 2026-11-19T23:52:37.403216Z
updated: 2026-11-20T01:04:08.344088Z
type: task
title: Pictures' alt text reaches the PDF, and a standalone flowchart's alt text is the same everywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2010
sprint: s6y6p7g
comments:
- id: 01M7V7PQ8KEAR5WN9SHC4ZXTY1
  author: Steve Vine
  at: 2026-11-20T01:04:02.323364Z
  text: |-
    Done — PR #2009, merged 0ed475e89.
    The PDF is now tagged. Every picture (image, drawing, text diagram, flowchart, and the cover logo) is a figure carrying its alt text where a screen reader finds it.
    A picture with no alt text of its own reads its caption. Without a caption it reads the default: "Diagram" for a drawing or text diagram, "Picture" for an image, and a flowchart's caption and step count. Word uses the same rule.
    A standalone flowchart reads "Flowchart: <title>, N steps" on the Read tab, in the PDF and in Word, both on its own page and when shown in a document. The "version N" under it is no longer part of what's read aloud.
    Tagging doesn't change how the PDF looks. A long document was compared page by page with and without tags and came out identical: the same pages, fonts and breaks. The file is about twice the size.
    Cached PDFs and Word files are made afresh after the deploy.
    Assumption: an image with neither alt text nor a caption reads "Picture" in the PDF and Word rather than being marked decorative. The PDF engine can't mark a picture as decorative, and a figure with no alt text fails the PDF accessibility checkers. The Read tab still treats such an image as decorative.
    To check on staging: export the PDF of a document with each kind of picture and open it in a PDF reader's accessibility or tags view (e.g. Acrobat's Tags panel). Each picture shows its alt text.
assignee: steve
label:
- bug
priority: medium
task_status: review
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