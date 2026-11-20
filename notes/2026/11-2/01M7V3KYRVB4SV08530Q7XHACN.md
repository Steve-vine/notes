---
id: 01M7V3KYRVB4SV08530Q7XHACN
created: 2026-11-19T23:52:37.403216Z
updated: 2026-11-20T14:05:05.260244Z
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
- id: 01M7VAPMH3Y3GEGHJT1H6DJ1FM
  author: Steve Vine
  at: 2026-11-20T01:56:25.251226Z
  text: |-
    Pre-UAT on staging 0ed475e8 — Passed
    Tested as E2E Admin A, E2E Test Company. PDFs checked with pymupdf (catalog, structure tree, every /Figure and its /Alt); Word with python-docx (each picture's alt-text field).
    - Every picture is a tagged figure with its alt text: Passed. The PDF is now tagged (/MarkInfo Marked, /StructTreeRoot, /Lang en).
      - "E2E pre-UAT COM-2004 every kind of picture": 8 Figures, each with /Alt: Logo; Picture (image, no alt or caption); E2E alt one (image); E2E diagram alt text (text diagram); E2E caption for the diagram (a diagram with only a caption); E2E drawing alt text; E2E flowchart alt text written by hand; Flowchart: E2E pre-UAT COM-1907 Service request handling, 4 steps (standalone).
      - Defaults, in "E2E pre-UAT COM-2009 unresized pictures" (nothing written): image → "Picture", drawing → "Diagram", text diagram → "Diagram", own flowchart → "Flowchart, 4 steps". Word gives each picture the same text.
      - Each figure's box is on its picture (e.g. the text diagram's is 300×72).
    - Tagging doesn't change how it looks: Passed. I re-exported two published documents that tester C exported in round 3 (untagged then): "E2E pre-UAT COM-1960 fit to page" (3 pages) and "E2E pre-UAT COM-1904 flowchart document" (6 pages, portrait and landscape). Same page count and sizes, same fonts, every word in the same position, and the rendered pages are pixel-identical (0.0000% differing).
    - A standalone flowchart's default alt text is the same everywhere: Passed. "Flowchart: E2E pre-UAT COM-1907 Service request handling, 4 steps" on the Read tab, in the editor, in the PDF and in Word, when shown in a document. The same on the flowchart's own page and in its own PDF and Word export. "version 5" no longer appears in it.
    - Cached PDFs of published documents made afresh: Passed. The two published documents above were untagged in round 3 and are tagged now.
    - Tests check the actual PDF: Passed (test_pdf_alt_text.py reads /Alt from the PDF's structure tree with pypdf, for each kind, plus the defaults and a before/after look).
    Observation: in Word the cover logo has no alt text, while the PDF reads it as "Logo".
    Files: ~/compass-uat/s6y6p7g/COM-2010/ (r3re-every-kind.pdf/.docx, r3re-standalone-own.pdf/.docx, r3re-now-*.pdf against ~/compass-uat/s6y6p7g/COM-1998/r3-unchanged-*.pdf); defaults in ~/compass-uat/s6y6p7g/COM-2009/r3re-unresized.pdf
assignee: steve
label:
- bug
priority: medium
task_status: done
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