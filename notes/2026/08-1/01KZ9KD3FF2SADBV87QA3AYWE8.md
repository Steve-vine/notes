---
id: 01KZ9KD3FF2SADBV87QA3AYWE8
created: 2026-08-05T18:36:35.695707Z
updated: 2026-08-05T19:41:51.719437Z
type: task
title: Sprint list multi-select
project: 01KY6W9951TW0904DT0GGJVGE7
number: 393
sprint: segj1dz
comments:
- id: 01KZ9M5VBR38M0RVYVQY6WM69P
  author: Steve Vine
  at: 2026-08-05T18:50:06.583844Z
  text: |-
    PR #383 — https://github.com/Steve-vine/notuvia/pull/383

    The sprint filter is now a selection rather than one-of: picked sprints OR together, empty = All Tasks. Cmd/Ctrl-click multi-selects in the right panel's sprint list (the kanban sidebar's multi-project idiom); the filter menu's Sprints section became checkboxes like every other section there. Stored per project as an array, with the old bare string read back as a one-sprint selection.

    Side effect: a card whose sprint reference is stale now filters under Unassigned Tasks instead of matching nothing — matching the tallies' counting rule.

    check / test / build green; new sprintFilter.test.ts covers the storage round-trip and the legacy migration. Not yet clicked through in the running app.
assignee: steve
priority: medium
task_status: done
---
Allow multiple selecting of sprints in the planner sprint list.