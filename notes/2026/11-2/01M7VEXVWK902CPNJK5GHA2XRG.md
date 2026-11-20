---
id: 01M7VEXVWK902CPNJK5GHA2XRG
created: 2026-11-20T03:10:16.467756Z
updated: 2026-11-20T03:48:26.482252Z
type: task
title: A document's flowchart picture saved in the background uses the house style's colours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2019
sprint: s6y6p7g
comments:
- id: 01M7VG4N818D4WWGBR6AWHQ8WB
  author: Steve Vine
  at: 2026-11-20T03:31:27.617676Z
  text: |-
    Done — PR #2014, merged 009a2b0d.

    A document's Edit tab now draws a missing flowchart picture only once the house style has loaded, or once the canvas's 3-second wait runs out. Before, it drew it at about 0.6 s, in the fallback blue.

    Once the house style is in, any flowchart picture saved in exactly the fallback colours is drawn again in the house colours and saved. That covers pictures saved blue on earlier visits, and a house style that arrives late. Nobody needs to press Done. Pictures already in the house colours, and charts that look the same either way, are left alone. Standalone flowcharts get the same correction.

    Assumptions:
    - "Wrong colours" means exactly the fallback colours for that chart. Pictures from older versions with other default colours are left alone.
    - Correcting a picture changes the draft, as drawing a missing one already did. So a published document with a blue picture shows unpublished changes after its Edit tab is opened.

    To check on staging:
    1. Open "E2E pre-UAT COM-2017 no picture yet". Its blue pictures should be redrawn in the house colours when the Edit tab opens.
    2. Publish it and export the PDF. The pictures should print in the house colours.
    3. Add a new flowchart through Polaris and open the Edit tab. The picture should be saved once, in the house colours.
- id: 01M7VH3R7JFEMZ216T3X1CA6Y7
  author: Steve Vine
  at: 2026-11-20T03:48:26.482094Z
  text: |-
    Pre-UAT on staging 009a2b0d — Passed
    Tested as E2E Admin A in E2E Test Company, in headless Chromium with its cache off. The pictures' colours were read from the saved pictures, and from the PDF and Word with python.
    - A picture that arrives without one is saved in the house colours, once: Passed.
      - I added a new flowchart to a fresh document through the Compass-staging connection ("E2E pre-UAT COM-2019 Polaris flowchart picture"), then opened its Edit tab on a normal connection.
      - The house style loaded at 0.6–0.7 s. The picture was saved once at 0.71 s, in #e9e9e9 / #212121 (r3fin2-05).
    - The background save waits for a late house style, within the canvas's limit: Passed.
      - I added a second flowchart through the connection, and held up the house-style requests by 4.5 s each, so the stylesheet arrived at 9.5 s.
      - The picture was saved in the fallback #e7f5ff / #1971c2 at 3.4 s, the 3-second limit. It was saved again in #e9e9e9 / #212121 at 9.5 s, as soon as the stylesheet arrived, with no Done. It ended in the house colours (r3fin2-06, r3fin2-07).
    - Pictures already saved in the wrong colours are corrected the next time the Edit tab opens, without Done: Passed.
      - "E2E pre-UAT COM-2017 no picture yet" had two blue pictures (#e7f5ff / #1971c2) and two grey ones.
      - On opening its Edit tab, the house style was in by 0.97 s. Both blue pictures were redrawn and saved in #e9e9e9 / #212121 at 1.0 s. The two grey ones were left alone. Nobody pressed Done (r3fin2-01).
    - PDF, Word and Read tab show the house colours: Passed.
      - I published it as v2. The Read tab shows the four corrected pictures (r3fin2-02).
      - PDF: every flowchart is drawn in #e9e9e9 fill and #212121 border, with no blue anywhere (r3fin2-03-pdf-p2/p3).
      - Word: all four pictures are #e9e9e9 / #212121, with no blue pixels.
    - A document whose pictures are already in the house colours gains no unpublished changes from opening Edit: Passed.
      - I reopened the published v2 and stayed 10 s. No picture was redrawn. Unpublished changes stayed false and the version stayed v2 (r3fin2-04).
    - Tests: not re-run here. They passed in the PR's CI.
    - Smoke: Passed.
      - A new standalone flowchart ("E2E pre-UAT COM-2019 smoke new standalone") opens with Start, in grey (r3fin2-08).
      - A document's own flowchart goes Edit → Done → Read: both pictures load and nothing says "Not yet drawn". Its PDF prints them in the house colours (r3fin2-09).
    Observation, not a defect:
    - Opening the Edit tab sends one save of the section that changes nothing: the same content with its keys in a different order. The document doesn't gain unpublished changes from it.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2019/ (r3fin2-*)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in the final re-check of round 3, on staging 85a42994, against COM-2018 and COM-2017.

**Steps:** add a flowchart to a document through Polaris (or another route that arrives without a picture: import, Turn into a flowchart). Open the document's Edit tab on a normal connection. Publish and export the PDF.

**Seen:**
- The Edit tab saves the missing picture about 0.6 s after the page opens, before the house-style list (0.86 s) and stylesheet (0.93 s) have loaded.
- The pictures come out pale blue (#e7f5ff / #1971c2), the PDF prints them blue, and they are never saved again.
- Opening the chart on the canvas shows grey (#e9e9e9 / #212121), and Done saves grey.
- This happens on every normal load, not only on a slow connection. COM-2018's builder had assumed this background save needn't be redone.

Evidence: ~/compass-uat/s6y6p7g/COM-2017/r3fin-10-polaris-pdf-p2.png, r3fin-11, r3fin-12. Test document "E2E pre-UAT COM-2017 no picture yet".

**Done when**
- A document's own flowchart that arrives without a picture is saved in the house colours, the same as the canvas and Done. Either the background save waits for the house style (with the same limit as the canvas), or a picture saved before the house style arrived is saved again, once, when it does.
- Pictures already saved this way in the wrong colours are corrected the next time the document's Edit tab opens, without anyone pressing Done.
- The PDF, Word and Read tab then show the house colours.
- Tests cover a picture saved in the background with the house style arriving after it, and the picture ending in the house colours.

Independent: frontend only.