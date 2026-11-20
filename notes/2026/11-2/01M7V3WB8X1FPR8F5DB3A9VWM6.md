---
id: 01M7V3WB8X1FPR8F5DB3A9VWM6
created: 2026-11-19T23:57:12.349977Z
updated: 2026-11-20T02:24:50.400763Z
type: task
title: A standalone flowchart's default shape colours are picker colours too
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2014
sprint: s6y6p7g
comments:
- id: 01M7V54CDK1K6TXP85W75EY2XD
  author: Steve Vine
  at: 2026-11-20T00:19:04.243072Z
  text: |-
    Done — PR #2003, merged 2409676ef.
    A standalone flowchart's page now uses the house style its type prints in, just as a document does. So a chart has the same default colours whether it's a document's own flowchart or a standalone one, and whether it's on its own page or shown in a document.
    Where no house style applies, the canvas, the picture and the Style panel all use the same defaults. A shape on Default is the picker's Light shade with a Primary border, and Style names and ticks them: "Default (Light shade)" and "Default (Primary)".
    The canvas opens once the house style has loaded, so it's never drawn in the defaults first. If the house style never loads, the canvas opens after 3 seconds anyway.
    Assumption: a standalone flowchart saved before this keeps its picture (Read tab, PDF, Word, and documents showing it) in the old colours until it's next opened in Edit and closed with Done.
    To check on staging: open a standalone flowchart, then Edit flowchart ▸ select a shape ▸ Style. The fill and border should be ticked defaults in the house style's colours. Click Done and check that the Read tab picture and the PDF match. Then compare it with the same chart added as a document's own flowchart in a document of the same type.
- id: 01M7VCANQ0PZ7GFR8WADGMXGGM
  author: Steve Vine
  at: 2026-11-20T02:24:50.400561Z
  text: |-
    Pre-UAT on staging d8749c62 — Passed
    - On a standalone flowchart, the default fill and border are picker colours, named and ticked; canvas, reading view, picture, PDF and Word match: Passed.
      - As E2E Admin A, on the new standalone "E2E pre-UAT COM-2016 new standalone" (Process type), a shape on Default is drawn #e9e9e9 with a #212121 border. Style reads "Default (Light shade)" and "Default (Primary)", and those swatches are ticked: Light shade #e9e9e9 and Primary #212121 (r3re-01).
      - The original failing chart, "E2E pre-UAT COM-1992 all shapes standalone", now does the same.
      - After Done, the Read tab picture matches the canvas, including one shape styled Accent shade with a dashed border (r3re-02). The fresh PDF's page 2 and the Word picture use #e9e9e9, #212121 and #cae1df (r3re-standalone.pdf and .docx).
    - The same default colours whether a document's own or standalone, on its own page or shown in a document: Passed for what's drawn now.
      - A document's own flowchart and a standalone one are both grey #e9e9e9 / #212121 (COM-1998 doc's own three boxes, the standalone three boxes reopened, and the new standalone). Staging has one house style, so every type prints in it.
      - Shown in a document: "E2E pre-UAT COM-1998 flowchart sizes" still shows the standalone three boxes (version 1) in the old light blue (r3re-03). That matches the builder's assumption: a picture saved before the fix keeps its old colours until it's next opened in Edit and closed with Done (and, for a document, republished).
      - I didn't put a newly saved standalone into a document. A document shows the same saved picture, which is grey on the Read tab.
    - Tests cover a standalone flowchart with no house-style sheet: Passed (standaloneColours.test.tsx).
    - See COM-2016: if the house style takes longer than about 3 seconds to load, the canvas opens in the fallback light blue and stays that way. That brings this task's mismatch back on a slow connection.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2014/r3re-*
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in pre-UAT of round 3, by Tester A on staging 7ea67f64, against COM-1991. Tester C saw the same effect: one 3-box chart drawn grey as a document's own flowchart and light blue as a standalone one.

**Steps:** on a standalone flowchart, add a shape and open Style.

**Seen:**
- The shapes are drawn #eef6fe with a #12558e border, but the pickers offer #e7f5ff and #1971c2.
- The panel reads plain "Default", with nothing ticked.
- In a document it works: "Default (Light shade)" and "Default (Primary)" are ticked, and everything matches.
- Cause: a standalone page has no house-style sheet. The shape colours fall back to the `--rt-…-fallback` values, while the picker falls back to its built-in swatches. COM-1991's test always sets up a house-style sheet, so it misses this case.

Screenshots: ~/compass-uat/s6y6p7g/COM-1991/r3-01-style-default-dark.png and COM-1998/r3-04-edit-paper-on.png (Tester C).

**Done when**
- On a standalone flowchart, the default fill and border are picker colours. Style names and ticks them ("Default (Light shade)" / "Default (Primary)"), and the canvas, reading view, picture, PDF and Word all match.
- The same flowchart has the same default colours whether it's a document's own or a standalone one, on its own page or shown in a document. A standalone flowchart uses the house style it is printed with.
- Tests cover a standalone flowchart with no house-style sheet on the page.

Independent: frontend only (look.ts / the canvas defaults), plus render.ts if it differs.