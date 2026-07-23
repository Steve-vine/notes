---
id: 01KY70KVYT2ATGR9GABFCKD24S
created: 2026-07-23T08:14:03.738551Z
updated: 2026-07-23T11:03:34.848843Z
type: task
title: Sections auto collapse
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 157
comments:
- id: 01KY70M0487C4DNPK0EX8KY634
  author: Steve Vine
  at: 2026-07-23T08:14:08.007869Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/139

    **What was done:** Expanding the Search section now collapses Browse and vice versa, via Svelte 5 function bindings on the two `CollapsibleSection`s in `Main.svelte`. The write-half of each binding sets its own flag and, only on *expand*, folds the sibling — so collapsing a section leaves the other alone and both can be collapsed at once.

    **Decisions on the fly:** Kept the flags on the tab's persisted browse state (no new storage); chose function bindings over `$effect` watchers so the two flags can't fight each other reactively.

    **Problems:** None. `npm run check` and `npm test` (109 tests) green.
sprint: sg5stzf
---
When the search is expanded, collapse the browse and vice verse.

## Agreed work

* In `Main.svelte`, replace the plain `bind:collapsed` bindings on the Search and Browse `CollapsibleSection`s with function bindings: when one section is expanded, the other is collapsed automatically. Collapsing a section leaves the other untouched (both may be collapsed at once).
* The collapsed flags stay on the tab's persisted browse state, so the accordion behaviour persists per tab as today.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-795 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04