---
id: 01M7Q8QX9TQ13MHJ27AFFFVGT7
created: 2026-11-18T12:05:12.122266Z
updated: 2026-11-18T12:05:16.858946Z
type: task
title: 'Browser smoke: the Library reader step finds its own "← Library" link, not "Back to the Library" as well'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1939
sprint: s2q1gxe
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found by the staging deploy of c15afb4d (Browser smoke run 44297397946, 2026-11-18): "every screen opens for <account>" failed for all six accounts at the Library reader step added by COM-1922.

The step looks for a link named "Library" inside the reader. That also matches the reader's **Back to the Library** button at the foot of the page, so the check finds two links and stops. The reader itself works. The check just needs to name the bar's own link exactly.

**Done when**
- The reader step in `app/e2e/src/crawl.ts` names the bar's link exactly.
- A standalone Browser smoke run on staging is green for every account.

Independent: test only, no product change.