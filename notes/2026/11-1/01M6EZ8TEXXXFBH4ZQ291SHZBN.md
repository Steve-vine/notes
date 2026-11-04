---
id: 01M6EZ8TEXXXFBH4ZQ291SHZBN
created: 2026-11-02T20:30:03.229097Z
updated: 2026-11-04T07:46:09.171584Z
type: task
title: Security Feed gaps found before review — watch lists show their last 7 and 30 days; a comeback's action is due from the comeback; no Raise on a not-relevant item, saying which right a missing Raise needs; a risk links back to the item it was raised from
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1531
sprint: s6xh9g1
comments:
- id: 01M6F8T9R7X6W4EXVJGGQNTNDX
  author: Steve Vine
  at: 2026-11-02T23:16:53.126969Z
  text: |-
    Done. Merged to main (PR #1545). It isn't on staging yet: the sprint deploys next, now that every task is in Review.

    What people see:
    - **Watch lists:** each list says "Matched 3 in the last 7 days · 11 in the last 30 days".
    - **My actions:** an item marked not relevant that comes back is due from the day it came back, so it no longer arrives already overdue.
    - **Item page:**
      - while an item is marked not relevant, Raise isn't offered. The page says "It's marked not relevant. Reopen it to raise from it." Compass also refuses a raise sent any other way, Polaris included;
      - someone who can raise only one of the two sees the button they can use, and the reason the other is missing ("Raising a vulnerability also needs Work vulnerabilities.").
    - **Risk page:** a risk raised from an item says "From the Security Feed: CVE-… · title", linking back to it.
- id: 01M6GA0JKJTXN8J5FG4WZTQTY3
  author: Steve Vine
  at: 2026-11-03T08:57:01.810074Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed** after a fix (COM-1535). **Couldn't check** a comeback's due date on live data.

    - **Watch lists:** the card shows "Matched … in the last 7 days · … in the last 30 days". After the history load both read 2,479, which COM-1538 fixes by counting by the item's own date.
    - **No Raise on a not-relevant item:** on a fresh load the page offers only "Confirm: affects us" and "Reopen", and the server refuses a raise with "It's marked not relevant. Reopen it to raise from it." But marking an item not relevant left Raise on the page until a reload, and Reopen didn't bring it back. Fixed in COM-1535 and checked on staging: Raise goes at once and comes back on Reopen.
    - **Risk links back:** R-32 says "From the Security Feed: CVE-2025-68686 · Fortinet FortiOS Exposure of Sensitive Information…", and the link opens the item.
    - **Comeback due date:** needs a source to revise a dismissed item. That didn't happen during the pass; the tests cover it.

    Screenshots: ~/compass-uat/sprint-102/COM-1531/, ~/compass-uat/sprint-102/COM-1535/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Sprint 102, Security Feed (ADR 0139). Found by checking COM-1519, COM-1523 and COM-1525 against their tasks before Review.

## What people see

- **Watch lists**: each list shows how many items it matched in the **last 7 days** and the **last 30 days** (COM-1519 asked for this; it was left out).
- **My actions**: when an item marked not relevant comes back (now exploited, now Critical, or now our versions), its action is due **from the day it came back**, not from when it first matched, so it doesn't arrive already overdue (COM-1523).
- **Item page**: **Raise vulnerability** and **Raise risk** aren't offered while the item is marked not relevant (reopen it first). If someone can raise one but not the other, the page says which right the other needs, e.g. "Raising a vulnerability also needs Work vulnerabilities" (COM-1525).
- **Risk page**: a risk raised from an item says **"From the Security Feed: CVE-2026-1234 · …"**, linking back to the item (COM-1525's "the risk links back to the item").

**Chain:** on the chain (API).

**Done when:** on staging, the Watch lists tab shows the two counts; a comeback's action has a due date counted from the comeback; a not-relevant item offers no Raise; a risk raised from an item links back to it.