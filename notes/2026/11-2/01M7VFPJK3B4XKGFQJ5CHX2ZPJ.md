---
id: 01M7VFPJK3B4XKGFQJ5CHX2ZPJ
created: 2026-11-20T03:23:46.147312Z
updated: 2026-11-20T03:52:07.257269Z
type: task
title: Browser smoke journey 6b selects the connection reliably before checking its end handles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2020
sprint: s6y6p7g
comments:
- id: 01M7VHACQTHJ0VXSSGENVK0EHM
  author: Steve Vine
  at: 2026-11-20T03:52:04.090354Z
  text: |-
    Done — PR #2015, merged dc346f30.
    Journey 6b now waits for Tidy up to finish (the button is usable again) and for the flowchart to stop moving before it aims at the connection. Stopped means every line and shape stays put on screen for 0.4 s.
    It still clicks the line's middle with the real mouse. It then checks that the connection's panel opened before it looks for the end handles. If the panel didn't open, it waits for the canvas to settle again and clicks once more.
    Locally (API, worker, the app and the mail catcher on this machine), 6b passed 6 runs in a row, 2 more after catching up with main, and 4 with the processor slowed six times.
    Assumption: the flake didn't reproduce locally, even with the old test on a slowed processor (3/3 passed). The fix targets the likely cause, aiming at a point worked out before Tidy up had finished, and the retry is the backstop.
    To check on staging: the Browser smoke goes green with 6b passing on the next deploy.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found on the staging deploy of 85a42994 (run 44663682398). Journey 6b failed at its COM-2013 step: after Tidy up, the test works out the connection's middle point and clicks it, but the connection wasn't selected, so `.fc-edge-end[data-edge-end="from"]` never appeared. The screenshot shows Start → Step, with no connection panel open.

The same build passed when the smoke was run again on its own (run 44665817279, 36/36), so this is a timing flake in the test. The likely cause: the click lands while Tidy up is still settling the layout, so the point it worked out is out of date.

**Done when**
- Before working out the line's middle point, journey 6b waits for the layout to settle after Tidy up: the edge path and the node positions stop changing.
- After clicking the line, it confirms the connection is selected (its panel is shown) before looking for the handles, and retries the click once if not.
- The step is still a real hit-test: the click goes through `page.mouse`, not a direct event.
- The smoke passes on staging, and 6b passes five runs in a row locally or in CI.

Independent: e2e test only (app/e2e/tests/journeys.spec.ts).