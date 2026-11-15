---
id: 01M7FSWDDAJ19FNGKF2VDE3J1B
created: 2026-11-15T14:30:50.026512Z
updated: 2026-11-15T15:22:31.073316Z
type: task
title: After re-ordering a check's columns, its history shows the change at once, in a short line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1858
sprint: spsp226
comments:
- id: 01M7FWTQRXTFFCJ8T2CG20HKBF
  author: Steve Vine
  at: 2026-11-15T15:22:20.829269Z
  text: |-
    **Passed**: pre-UAT on staging (build ef30ce5a), E2E Test Company, as E2E Admin A, 2026-11-15 15:20–15:22.

    Steps and what I saw:
    1. ACC.13 ▸ Evidence ▸ CHK-2's menu ▸ "Change the fields it keeps". The original order was allow_forking, archive_url, archived…
    2. On allow_forking's column menu I chose Move right (giving archive_url, allow_forking), then "Keep these fields". With no reload, a new entry appeared at the top of the history under the card: "Columns re-ordered: archive_url moved before allow_forking" (ran 15:20, by E2E Admin A). It's one short line and doesn't list all 102 columns.
    3. I went back into "Change the fields it keeps", chose Move left on allow_forking (back to allow_forking, archive_url) and clicked "Keep these fields". With no reload, a second line appeared at once: "Columns re-ordered: allow_forking moved before archive_url" (ran 15:22). CHK-2's original column order is restored.
    4. The earlier entries from 14:24 and 14:28 now also read briefly, e.g. "allow_forking moved before archive_url; name moved before node_id".

    The check's own page (Checks ▸ CHK-2) doesn't show these lines. CHK-2 has a rule, and a check with a rule has no capture history on its page, only the "Changes" list of rule changes. That has always been so: only a collected check without a rule shows the history there. CHK-2 is the only live collected check in E2E Test Company, so I couldn't check the own-page refresh. Steve: if you expect the history on a rule check's page too, that's a new task, not this one.

    Screenshots: ~/compass-uat/spsp226/COM-1858/ (01–06).
- id: 01M7FWV149Q8CQVWCQPP4PJAZ7
  author: Steve Vine
  at: 2026-11-15T15:22:30.408893Z
  text: |-
    Built and merged — PR #1843 (ef30ce5a). It's on staging (Browser smoke 32 passed) and passed the re-check (see the comment above).

    - After "Keep these fields", the check's history shows the new entry at once, with no reload. The same goes for ticking/unticking and lookups. Saving used to refresh the check but not its history.
    - The line says what moved, briefly, e.g. "Columns re-ordered: Approver moved before Status". With several moves it names three, then "and N more". Columns are named by their display name where they have one, and "Fields changed: …" uses display names too.
    - Tests: backend tests for the wording (one move, two, more than three, 102 columns, display names). A Vitest test fails without the fix.
assignee: steve
label:
- bug
priority: low
task_status: review
---
## What happened

Pre-UAT of COM-1844 on staging (36d3de6c), 2026-11-15. Fix-forward.

1. As E2E Admin A, ACC.13 ▸ Evidence ▸ CHK-2's menu ▸ "Change the fields it keeps".
2. Move a column (drag or Move right), then "Keep these fields".
3. The capture history under the card doesn't show the new "Columns re-ordered" entry. It appears only after reloading the page (seen twice).

Also: the "Columns re-ordered: …" line lists every kept column (102 on CHK-2), so one re-order makes a very long line.

## What people see

- After "Keep these fields", the check's history (on the Evidence card and on the check's own page) shows the new entry straight away, without a reload. The same goes for ticking/unticking ("Fields changed: …").
- The line says what moved, briefly: e.g. "Columns re-ordered: Approver moved before Status". When several moved, it names up to three and then "and N more". It never lists every column.

## Done when

- On staging, re-ordering CHK-2's columns in Edit fields shows the short history line under the card at once.
- Vitest covers the refresh after saving; backend/unit tests cover the short wording (one move, several moves).

**Independent** (screen + wording; no migration). Follows COM-1844.