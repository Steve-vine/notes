---
id: 01M7V90K9T9TRGHZ0KK1GTE585
created: 2026-11-20T01:26:54.522013Z
updated: 2026-11-20T14:05:05.300571Z
type: task
title: A new standalone flowchart opens with its Start shape again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2016
sprint: s6y6p7g
comments:
- id: 01M7VAP9M8T70KP493E1EBZ8TJ
  author: Steve Vine
  at: 2026-11-20T01:56:14.088752Z
  text: |-
    Done — PR #2011, merged d8749c62.
    A new standalone flowchart (New content ▸ Flowchart ▸ Edit ▸ Draw the flowchart) now opens on a Start shape. It's the same starting chart a document's own new flowchart gets. A flowchart that's already drawn opens exactly as it was saved. Cancel on an untouched new canvas has nothing to discard.
    The canvas still waits for the house style so it opens in its colours, but never more than about three seconds. That now holds even when Compass can't find out which house style it is, so the canvas always opens.
    Cause: COM-2014 didn't break this. A standalone flowchart has opened empty since it was first built. COM-2013's new smoke step was the first to expect a Start there.
    Checked: journeys 6 and 6b both pass against a local copy of Compass, including COM-2013's end-handle drag. With the fix taken out, 6b fails at the same line as on staging.
    Assumption: a saved flowchart whose shapes were all deleted also reopens with a Start.
    To check on staging: the Browser smoke's journey 6b is green after the next deploy.
- id: 01M7VCB7Y7VVSTQZ90YPMJ1AAF
  author: Steve Vine
  at: 2026-11-20T02:25:09.063572Z
  text: |-
    Pre-UAT on staging d8749c62 — Failed
    One defect: when the house style takes longer than about 3 seconds, the canvas opens in the fallback colours and never switches to the house style once it arrives.
    - A new standalone flowchart opens with its Start shape, whether the house style loads quickly, slowly or never: Passed.
      - As E2E Admin A: New content ▸ Flowchart (Process), "E2E pre-UAT COM-2016 new standalone" ▸ Create draft ▸ Edit ▸ Draw the flowchart. The canvas opened in 0.8 s with a single "Start" (r3re-02).
      - I then held up the house-style requests in the browser.
        - 1 s delay: Start, opened after 3.4 s, in the house colours.
        - 4–5 s delay: Start, opened after 3.1–3.6 s, four runs out of four.
        - Request failed: Start, after 0.6 s.
        - Request never answered: Start, after 3.6 s (r3re-05, r3re-06).
      - Cancel on the untouched canvas closed it straight away, with no "discard?" question (r3re-03).
      - Import (draw.io / Lucidchart) is still offered on the new canvas with its Start. A draw.io import replaced the Start with the imported chart (seen under COM-2012).
    - An existing standalone flowchart opens with exactly its saved shapes: Passed. "E2E pre-UAT COM-1998 standalone three boxes" opened with exactly its saved Start, Do the thing and End (r3re-10). "E2E pre-UAT COM-1992 crash isolate e1" opened with its 8 shapes and no Start added.
    - The house style still applies to the canvas once it loads: Failed when it loads late.
      - Normal load: Passed. Shapes are #e9e9e9 / #212121, the house style's Light shade and Primary.
      - Late load, as E2E Admin A on "E2E pre-UAT COM-2016 new standalone":
        - Steps: delay /api/v1/house-styles by 4–5 s (the house-style list, then its stylesheet, about 8–11 s in all). Then Edit ▸ Draw the flowchart, or Edit flowchart on an existing chart.
        - Expected: the canvas opens after about 3 s, and switches to the house colours when the stylesheet arrives.
        - Seen: the canvas opens in the fallback #e7f5ff / #1971c2 and stays that way. 15 s after it opened, with the house stylesheet linked on the page, Start was still pale blue. Style meanwhile ticks "Default (Light shade)" and "Default (Primary)" on the house swatches, #e9e9e9 and #212121. That is the same mismatch COM-2014 fixed, back on a slow connection. An existing chart behaves the same way (r3re-07, r3re-08, r3re-09, r3re-11).
      - Not tried: pressing Done in that state. It would presumably save the picture in the fallback colours.
    - Browser smoke journey 6b is green on staging, including COM-2013's end-handle drag: Passed. The Browser smoke step of the d8749c62 staging deploy (run 44657555871) succeeded.
    - Unit test for Start when the house style arrives late and never: Passed. standaloneStart.test.tsx has "opens with Start when the house style arrives late" and "… never arrives". No test checks that the colours change when it arrives late.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2016/r3re-*
- id: 01M7VEWDKV2GKABABDV09ZAHT7
  author: Steve Vine
  at: 2026-11-20T03:09:29.083433Z
  text: |-
    Re-check on staging 85a42994: "the house style still applies once it loads", for a late load, now Passed (fixed by COM-2018)
    - As E2E Admin A, I held up the house-style list and stylesheet by 4.5 s each, with the browser cache off. A new standalone flowchart's canvas opened with Start after 3.3 s, in the fallback #e7f5ff / #1971c2, with Style agreeing.
    - When the stylesheet arrived, at about 10 s, the canvas turned #e9e9e9 / #212121, and Style ticked the same colours. Done saved a grey picture, and the Read tab shows it.
    - On a normal load, a new standalone still opens with just Start, in #e9e9e9.
    - One remaining gap, logged under COM-2018: a document's own flowchart that arrives without a picture gets a background picture saved before the house style loads, so its PDF prints it pale blue.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2018/r3fin-*
assignee: steve
label:
- bug
priority: urgent
task_status: done
---
Found by the Browser smoke on staging 0ed475e8 (run 44651228349, journey 6b). It probably came in with COM-2014, which made a standalone flowchart's page wait for its house style before opening the canvas.

**Steps:** New content ▸ Flowchart, give it a title, then Create draft ▸ Edit ▸ Draw the flowchart.

**Seen:** the canvas opens empty, with no Start shape, so journey 6b times out waiting for "Start". A document's own new flowchart still opens with Start (journey 6 passed).

Screenshot: /tmp/claude-1000/-home-steve-code-compass/8b91df11-1d81-452f-b771-cfed74aa6d2e/scratchpad/smoke-art/test-failed-1.png

**Done when**
- A new standalone flowchart opens with its Start shape, the same starting chart as a document's own new flowchart, whether the house style loads quickly, slowly or never.
- An existing standalone flowchart opens with exactly its saved shapes.
- The house style still applies to the canvas once it loads (COM-2014).
- Browser smoke journey 6b is green on staging. That includes COM-2013's step of dragging a connection's end handle.
- A unit test covers a new standalone flowchart opening with Start when the house style arrives late and when it never arrives.

Independent: frontend only.