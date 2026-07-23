---
id: 01KY71BQ8J8WN6J44X3ZAENQD9
created: 2026-07-23T08:27:05.362713Z
updated: 2026-07-23T08:27:10.021035Z
type: task
title: Swap the Dependancies and Taxonomies sections around.
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 214
comments:
- id: 01KY71BVT5F86Y9277H4C2002X
  author: Steve Vine
  at: 2026-07-23T08:27:10.020651Z
  text: |-
    Steve Vine · 2026-07-06:

    **Build complete — PR [#197](https://github.com/Steve-vine/notuvia/pull/197)**, branch `steve/dev-867-swap-the-dependancies-and-taxonomies-sections-around`.

    Pure markup reorder in `NoteProperties.svelte`: the Taxonomies `CollapsibleSection` now sits directly under Properties, with the task-only Dependencies section below it. No logic or style changes. Built as an independent branch off main (not stacked on #196); whichever of the two merges second may need a trivial rebase since both touch the same file. svelte-check clean, 129 tests pass, build OK.
---
So tax is above dependancies.

---

Linear DEV-867 · Backlog · created 2026-07-06 · done 2026-07-06