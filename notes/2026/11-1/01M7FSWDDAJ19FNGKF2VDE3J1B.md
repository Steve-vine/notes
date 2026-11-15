---
id: 01M7FSWDDAJ19FNGKF2VDE3J1B
created: 2026-11-15T14:30:50.026512Z
updated: 2026-11-15T14:30:58.335603Z
type: task
title: After re-ordering a check's columns, its history shows the change at once, in a short line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1858
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
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