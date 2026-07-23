---
id: 01KY70NCE6W3ZK4F3TF314KJD5
created: 2026-07-23T08:14:53.382556Z
updated: 2026-07-23T09:08:57.994565Z
type: task
title: Taxonomy positioning in browse section
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 160
comments:
- id: 01KY70NG851ZSQ2CM7WWXJ3K96
  author: Steve Vine
  at: 2026-07-23T08:14:57.285484Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/142

    **What was done:** The × on each browse-axis row is now always rendered, disabled while only one level is chosen — so the select keeps a constant width and nothing jumps when a second taxonomy is added. It reuses the existing `.axis-btn:disabled` styling, matching how ↑/↓ already behave at the ends of the list.

    **Decisions on the fly:** None of note — `removeAxis` already guarded against removing the last level, so this was purely a render change in `BrowseSection.svelte`.

    **Problems:** None. `npm run check` and `npm test` green.
---
When only one taxonomy is selected there is no 'X' close button on the right of it, when a second tax is added, an 'X' is added which resized the first box.  It would be better if the 'X' was always there but disabled when only one tax exists.

## Agreed work

* In `BrowseSection.svelte`, always render the × (remove level) button on every axis row, disabled when only one axis is chosen — matching the ↑/↓ buttons, which are already always present but disabled at the ends. The axis select then never resizes when a level is added or removed.
* `removeAxis` in `Main.svelte` already guards against removing the last level; no logic change needed.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-798 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04