---
id: 01KY70QKG7HJ7CEVS36EV0QHBF
created: 2026-07-23T08:16:06.151045Z
updated: 2026-07-23T11:03:35.556717Z
type: task
title: Project selectors
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 165
comments:
- id: 01KY70QQDHQ8WH83CM2RD2DSWJ
  author: Steve Vine
  at: 2026-07-23T08:16:10.161032Z
  text: |-
    Steve Vine · 2026-07-04:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/147

    **What was done:** In `KanbanView.svelte`'s `loadBoard`, a scoped projects selection now maps the non-matching columns to empty (`notes: []`) instead of filtering them out — all status columns stay visible and the board keeps its shape when switching between All/Active/Closed.

    **Decisions on the fly:** Kept "unstatused counts as active" from DEV-801: on the Closed board the "no status" column shows empty. A side benefit of keeping the columns: you can now drag a project into a done column directly from the Active board.

    **Problems:** None. `npm run check` and `npm test` green.
sprint: sg5stzf
---
When selecting 'Active Projects' and 'Closed Projects' current behaviour is to hide some columns.  This shouldn't happen and all columns remain visible.

## Agreed work

* Change the DEV-801 scope behaviour in `KanbanView.svelte`: a scoped projects board keeps **every** status column visible and instead empties the cards out of the non-matching columns — "Active Projects" shows all columns with the done columns empty; "Closed Projects" the reverse. The board's shape no longer changes with the selection.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-804 · Left Panel Improvements · created 2026-07-04 · done 2026-07-04