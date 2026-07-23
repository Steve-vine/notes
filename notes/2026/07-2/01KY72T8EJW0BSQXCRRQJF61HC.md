---
id: 01KY72T8EJW0BSQXCRRQJF61HC
created: 2026-07-23T08:52:30.290559Z
updated: 2026-07-23T09:18:08.745695Z
type: task
title: Sprint progress
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 315
comments:
- id: 01KY72TCXZ7BHAVT0KRJSXFEW4
  author: Steve Vine
  at: 2026-07-23T08:52:34.879452Z
  text: |-
    Steve Vine · 2026-07-12:

    **Plan (agreed scope for this brief):**

    The sprint progress bars on the Project note page (both Sprint 0 and the listed sprints) turn green when every task in the sprint is done; all other states keep the existing accent blue.

    - `NotePane.svelte`: add a `done` class to the `.fill` span when the sprint's closed count equals its total (and the total is > 0 — an empty sprint stays blue at its 0%), plus a `.fill.done { background: var(--success) }` rule. Using the exact count rather than the rounded percentage means 249/250 (which rounds to 100%) stays blue — green strictly means "all done".

    No backend or data changes.
- id: 01KY72THHXXBV5WBM95AK3SF8K
  author: Steve Vine
  at: 2026-07-23T08:52:39.612514Z
  text: |-
    Steve Vine · 2026-07-12:

    **Done — in review.** PR: https://github.com/Steve-vine/notuvia/pull/301

    What was done: exactly the plan — `class:done` on the `.fill` span of both the Sprint 0 row and the listed sprint rows, keyed on `closed === total && total > 0`, with `.fill.done { background: var(--success) }`. No backend changes.

    Decision made on the fly: none beyond the plan. `npm run check` / `npm test` (180) / `npm run build` all clean.

    Merge order: this lands before DEV-969, which extends the same bars with red slippage states.
sprint: segj1dz
---
On the project note, show 100% sprint progress bar as green.  All other as the existing blue colour.

---

Linear DEV-968 · Enhancements · created 2026-07-12 · done 2026-07-12