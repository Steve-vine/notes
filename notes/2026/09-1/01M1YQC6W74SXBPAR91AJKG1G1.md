---
id: 01M1YQC6W74SXBPAR91AJKG1G1
created: 2026-09-07T20:01:27.431446Z
updated: 2026-09-07T20:01:55.996366Z
type: task
title: The sort convention, pinned by a test
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 616
sprint: sa2t9sq
assignee: steve
label:
- chore
priority: medium
task_status: todo
---
A sweep across fifty files decays the moment someone adds the fifty-first. `screen-conventions.test.ts` already exists for exactly this reason (COM-542, the toggle-label rule) — this task teaches it the sort rule, so a new table that forgets to sort fails CI instead of quietly shipping.

## The check

Walk every `.tsx` outside `node_modules` and tests, find each `<Table.Thead>`, and assert its heading cells are `SortableTh` rather than bare `Table.Th`.

Two escapes, both explicit and both cheap to read:

- A column that legitimately does not sort — row actions, an icon, a selection checkbox — is marked in the source with a short comment the test recognises, next to the `Table.Th`. Silence is not an escape.
- A whole table that is not a list — a two-column facts panel, an editable ordered ladder — is marked the same way on the `Table.Thead`.

The failure message names the file, the heading text, and points at the *Every list sorts* section of `brief/information-architecture.md`, the way the toggle check already does.

## Sequencing

**This lands last.** Until the six sweep tasks have merged, the check fails on every page they have not reached yet. It is the closing task of the sprint, not the opening one.
