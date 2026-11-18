---
id: 01M7Q8QX9TQ13MHJ27AFFFVGT7
created: 2026-11-18T12:05:12.122266Z
updated: 2026-11-18T12:37:35.831679Z
type: task
title: 'Browser smoke: the Library reader step finds its own "← Library" link, not "Back to the Library" as well'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1939
sprint: s2q1gxe
comments:
- id: 01M7QAK6S2E163685MGQDCX13N
  author: Steve Vine
  at: 2026-11-18T12:37:35.138471Z
  text: |-
    Done: merged as PR #1933 (18e4c1b7). The reader step now looks for the bar's "Library" link by its exact name, so it no longer also matches "Back to the Library". Test only, no product change.

    One PR check failed once: an unrelated Evidence Collection test (CollectionCard, "never offers the fields it leaves out"). It passed when the job was re-run.

    Verified: a standalone Browser smoke run on staging (run 44303617632, against the c15afb4d deploy) passed 36 of 36. That includes the Library crawl for every account (folder, Esc, chip, Not in a folder, reading pane, reader and back) and the arranging journey.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by the staging deploy of c15afb4d (Browser smoke run 44297397946, 2026-11-18): "every screen opens for <account>" failed for all six accounts at the Library reader step added by COM-1922.

The step looks for a link named "Library" inside the reader. That also matches the reader's **Back to the Library** button at the foot of the page, so the check finds two links and stops. The reader itself works. The check just needs to name the bar's own link exactly.

**Done when**
- The reader step in `app/e2e/src/crawl.ts` names the bar's link exactly.
- A standalone Browser smoke run on staging is green for every account.

Independent: test only, no product change.