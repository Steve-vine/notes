---
id: 01M7VCCJBVEPQPHKGDWHKTR8VD
created: 2026-11-20T02:25:52.507641Z
updated: 2026-11-20T14:05:05.314041Z
type: task
title: The flowchart canvas takes the house style's colours even when the house style loads late
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2018
sprint: s6y6p7g
comments:
- id: 01M7VDN4GE2H0JFR6Q113XQAAG
  author: Steve Vine
  at: 2026-11-20T02:48:01.806535Z
  text: |-
    Done — PR #2013, merged 85a42994.

    If the house style arrives after a flowchart's canvas has opened (past the 3-second wait), the canvas now switches to the house colours without a reload. So do the Style panel's Default swatches and the picture saved on Done. Until the house style arrives, the canvas and Style both show the same fallback colours. This works the same for standalone flowcharts and a document's own flowchart. A standalone flowchart whose missing picture was saved in the fallback colours is saved again once the house style arrives.

    Assumption: a document's own flowchart that arrives without a picture and is saved in the background (COM-2017) isn't saved again when a late house style arrives. Its canvas, Style and Done are covered by the shared fix.

    To check on staging:
    1. Hold up the house-style requests by 4–5 s, then open a standalone flowchart's canvas. It opens pale blue and turns grey (#e9e9e9 / #212121) when the house style arrives.
    2. Style ticks "Default (Light shade)" and "Default (Primary)" on those colours.
    3. After Done, the Read tab picture is grey.
- id: 01M7VEW1Z4GVSWF2PTMB1XJ756
  author: Steve Vine
  at: 2026-11-20T03:09:17.156093Z
  text: |-
    Pre-UAT on staging 85a42994 — Failed (one point: a document's own flowchart's background picture)
    Tested as E2E Admin A in E2E Test Company, headless Chromium with its cache off. I held up the house-style list and its stylesheet by 4.5 s each, so the stylesheet arrived about 9.5 s after the page loaded. The test chart is the new standalone "E2E pre-UAT COM-2018 late house style".
    - Canvas, Style and the picture saved on Done switch to the house colours without a reload; before the style arrives, canvas and Style agree on the fallback: Passed.
      - Edit ▸ Draw the flowchart: the canvas opened with Start 3.3 s after the click, in the fallback colours: fill #e7f5ff, border #1971c2.
      - Style ticked "Light shade" and "Primary", whose swatches were those same two colours (r3fin-05).
      - When the stylesheet arrived (about 10.3 s), the shapes turned #e9e9e9 / #212121. The same two Style ticks now showed #e9e9e9 / #212121 (r3fin-06).
      - Done: the saved picture is #e9e9e9 / #212121, and the Read tab shows that grey picture (r3fin-07).
    - The picture saved on Done uses the colours in force when Done is pressed, and the next Done corrects an early one: Passed. With the delay on, I pressed Done at 4.2 s, before the style arrived: the picture was saved in #e7f5ff / #1971c2. It was not re-saved when the style arrived. The next Done, on a normal load, saved #e9e9e9 / #212121.
    - The same for a document's own flowchart: canvas, Style and Done Passed; the picture drawn in the background Failed.
      - Canvas, Style and Done, Passed. With the delay on, I opened a document's own flowchart in "E2E pre-UAT COM-2017 no picture yet" by double-click at 1.5 s. It showed fallback #e7f5ff / #1971c2, and Style ticked those swatches. It switched to #e9e9e9 / #212121 at 10 s, and Style switched with it. Done saved a grey picture (r3fin-09, r3fin-10).
      - The background picture, FAILED. Steps:
        1. Add a flowchart to a document through Polaris (I used the Compass-staging connection).
        2. Open the document's Edit tab on a normal connection, with no delay.
      - Seen: the Edit tab saves the missing picture at about 0.6 s. That's before the house-style list (0.86 s) and stylesheet (0.93 s) have loaded. All four such pictures are #e7f5ff / #1971c2, and the published PDF prints them pale blue (COM-2017/r3fin-10-polaris-pdf-p2.png). They are never saved again. Opening the same chart on the canvas shows grey, and Done saves #e9e9e9 / #212121.
      - Expected: the picture in the house colours, as the canvas and Done give, and as a standalone flowchart now gets. A Polaris standalone flowchart's page-saved picture was saved in the fallback at 3.4 s and saved again in grey at 9.5 s once the style arrived. Passed for standalone.
      - The builder's assumption covers re-saving a document's own background picture when the style arrives late. But this happens on every normal load, not only on a slow connection. Steve to decide.
    - Tests: Passed. lateHouseStyle.test.tsx covers a document's own flowchart, a standalone's canvas, Style and Done picture, and re-saving a missing picture. Not re-run here.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2018/ (r3fin-*)
- id: 01M7VH3YDBV7DXR1VJ816ASWNF
  author: Steve Vine
  at: 2026-11-20T03:48:32.810796Z
  text: |-
    Re-check on staging 009a2b0d: the background picture now Passes (fixed by COM-2019)
    Tested as E2E Admin A in E2E Test Company.
    - Normal connection: I added a flowchart to a document through the Compass-staging connection and opened its Edit tab. Its picture was saved once, after the house style had loaded, in #e9e9e9 / #212121.
    - House style held up by 4.5 s: the picture was saved in the fallback at 3.4 s, then saved again in the house colours at 9.5 s when the stylesheet arrived. No Done needed.
    - The two blue pictures in "E2E pre-UAT COM-2017 no picture yet" were corrected as its Edit tab opened. Its published PDF and Word print them grey.
    So the one Failed point in my earlier comment now passes. Details are on COM-2019; screenshots in ~/compass-uat/s6y6p7g/COM-2019/ (r3fin2-*).
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in the round 3 re-check, by Tester A on staging d8749c62, against COM-2016 and COM-2014.

**Steps:** hold up the house-style requests by 4–5 s each, so the stylesheet arrives about 8–11 s after the page loads. Then open a standalone flowchart's canvas with Draw the flowchart, or Edit flowchart on an existing chart.

**Seen:**
- The canvas opens after about 3 s in the fallback colours (#e7f5ff fill, #1971c2 border) and keeps them. 15 s later the stylesheet was on the page, but the shapes were still pale blue.
- Style ticks the grey house swatches (#e9e9e9 / #212121), so COM-2014's mismatch comes back on a slow connection.
- Pressing Done in that state would presumably save the picture in the wrong colours.

Screenshots: ~/compass-uat/s6y6p7g/COM-2016/r3re-08-late-style-15s.png, r3re-09-late-style-panel.png, r3re-11-late-style-existing.png

**Done when**
- When the house style arrives after the canvas has opened, the canvas, the Style panel's default swatches and the picture saved on Done all switch to the house colours without a reload. Before it arrives, the canvas and Style agree on the fallback.
- The picture saved on Done always uses the colours in force when Done is pressed. Done made before the house style arrives saves pictures that the next Done corrects.
- The same applies to a document's own flowchart if its house style can arrive late.
- Tests cover a house style arriving after the 3 s limit, with the canvas, Style and the saved picture all switching.

Independent: frontend only.