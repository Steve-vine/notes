---
id: 01M1YQC6W74SXBPAR91AJKG1G1
created: 2026-09-07T20:01:27.431446Z
updated: 2026-09-08T20:10:01.894365Z
type: task
title: The sort convention, pinned by a test
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 616
sprint: sa2t9sq
blocked_by:
- 01M1YQA7AJTVZVAX9KPZ9ZA7PW
- 01M1YQAJHWCMWXW6AB0SXRBZ3F
- 01M1YQATEE7BDGQRGV3PJ2BZM3
- 01M1YQB6FSAA24YMPGNHYQVJNC
- 01M1YQBFMEPYCNRXQDCFRWMEV1
- 01M1YQBTQVTZDRDCQEHV394BH5
comments:
- id: 01M20J6S7DMZPCTXZY8XTXRYD4
  author: Steve Vine
  at: 2026-09-08T13:09:35.597072Z
  text: |-
    Done — PR #629 merged to main, last of the sprint.

    screen-conventions.test.ts now walks every .tsx outside node_modules and tests, finds each <Table.Thead>, and requires its heading cells to be SortableTh. Two escapes, both written in the source beside the thing they excuse — silence is not one:
    - {/* no-sort: row actions */} immediately before a Table.Th (row actions, an icon, a selection checkbox, a value the server does not order by). An expression such as {canEdit && <Table.Th/>} between comment and tag is fine; another tag is not.
    - {/* no-sort-table: an ordered ladder edited in place */} immediately before the Table.Thead (a facts panel, a row order that is the data, a peek at a paged answer).

    The failure names file, line and heading and points at the brief's Every list sorts section. The checker is itself tested against synthetic sources so a clean sweep is not a checker that sees nothing.

    On main the sweep is complete: zero offenders. Four small marks were needed for tables the sweeps did not touch — the action columns on the three COM-272 directory tabs and the Risks overview heat-map grid. The brief records the test and the escapes.
assignee: steve
label:
- chore
priority: medium
task_status: done
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
