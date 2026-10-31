---
id: 01M68M6CFFE50WG8660NE4JHNN
created: 2026-10-31T09:21:02.447111Z
updated: 2026-10-31T09:22:38.404131Z
type: task
title: The Actions screen opens on My actions and Upcoming only, sorted by due date, with a filter chip for every Type that has something in it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1475
sprint: scpaa6p
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 100, Actions (ADR 0137 rule 9).

## What people see

- **My actions** replaces "Owned by me" and is **on by default**. It covers what you own and what's owned by a role you hold (COM-1471).
- **Upcoming only** is new and **on by default**. It hides anything due beyond the horizon, i.e. the *Later* rows (Admin ▸ Actions, 90 days).
- "Overdue only" and "This company only" stay as they are.
- **Sorted by due date**, overdue first, then nearest. This is the default, and every column can still be sorted. Check the current order and fix it if it isn't already this.
- **Type chips:**
  - one chip for every Type (Gap, Risk, Treatment, Incident, Vulnerability, DDQ, Contract review, Audit request, Access request, Vendor, Asset, Policy, Plan activity…);
  - **only chips with a count above zero are shown**, counted under the current switches;
  - All stays first;
  - a link to a type that has nothing still opens and shows the empty state.
- Columns: **Type · What · Action · Company** (when not scoped) **· Owner · Due · Status**.
- The empty state, when My actions is on, says "Nothing due for you in the next 90 days" and offers to turn off Upcoming only.
- The Portal's Actions page shows the same columns and statuses, without the switches it doesn't need.

## Notes (technical)

- Switches stay in the address (`useQueryFlag`). The defaults flip to on, so `?mine=0` / `?upcoming=0` turn them off and old links still work.
- Chips come from the Type labels (COM-1470), replacing `ACTION_TYPE_FILTER_OPTIONS` and `matchesTypeFilter`. The old `?type=gap` address keeps working.
- Screen conventions: `SortableTh` on every column, and `w="fit-content"` on the switches.

**Chain:** on the chain (API filter for upcoming). Blocked by COM-1471 and COM-1474.

**Done when:** on staging, as E2E Admin A, Actions opens showing only their own actions due within 90 days, nearest first. Every chip shown has a count above zero, and turning My actions off adds others' rows and chips.