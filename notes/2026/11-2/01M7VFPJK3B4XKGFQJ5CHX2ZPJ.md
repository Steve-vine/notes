---
id: 01M7VFPJK3B4XKGFQJ5CHX2ZPJ
created: 2026-11-20T03:23:46.147312Z
updated: 2026-11-20T03:24:25.465094Z
type: task
title: Browser smoke journey 6b selects the connection reliably before checking its end handles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2020
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found on the staging deploy of 85a42994 (run 44663682398). Journey 6b failed at its COM-2013 step: after Tidy up, the test works out the connection's middle point and clicks it, but the connection wasn't selected, so `.fc-edge-end[data-edge-end="from"]` never appeared. The screenshot shows Start → Step, with no connection panel open.

The same build passed when the smoke was run again on its own (run 44665817279, 36/36), so this is a timing flake in the test. The likely cause: the click lands while Tidy up is still settling the layout, so the point it worked out is out of date.

**Done when**
- Before working out the line's middle point, journey 6b waits for the layout to settle after Tidy up: the edge path and the node positions stop changing.
- After clicking the line, it confirms the connection is selected (its panel is shown) before looking for the handles, and retries the click once if not.
- The step is still a real hit-test: the click goes through `page.mouse`, not a direct event.
- The smoke passes on staging, and 6b passes five runs in a row locally or in CI.

Independent: e2e test only (app/e2e/tests/journeys.spec.ts).