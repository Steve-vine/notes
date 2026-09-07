---
id: 01M1YQATEE7BDGQRGV3PJ2BZM3
created: 2026-09-07T20:00:41.93431Z
updated: 2026-09-07T22:31:49.813936Z
type: task
title: 'Vendor lists sort: the register and the vendor tabs'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 612
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Apply the sort convention from *Every list sorts* to Vendor Management.

## Pages

- `pages/VendorsPage.tsx` — the vendor register
- `vendors/detail/cards.tsx` — the tables on a vendor's detail tabs (the largest single collection of tables in the app: engagements, assessments, assurance, contacts, requests, history). Every one that lists many rows of the same kind sorts; the fact panels do not.
- `vendors/RequestGroupTable.tsx` — the grouped request tables

## Notes

- Risk tier sorts by rank, worst first, using the ladder from ADR 0060 — not alphabetically.
- Review and expiry dates sort as dates; a vendor with no next review sorts last.
- Where a table already opens in a deliberate order (an assurance profile's themed column groups, a request group's own sequence), that stays the default and sorting is the overlay.

Tests: the register plus at least two of the detail tabs, asserting reorder, reverse and `aria-sort`.
