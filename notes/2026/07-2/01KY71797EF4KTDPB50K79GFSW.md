---
id: 01KY71797EF4KTDPB50K79GFSW
created: 2026-07-23T08:24:39.918881Z
updated: 2026-07-23T08:24:46.01468Z
type: task
title: Improve dashboard layout
label: brief
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 204
comments:
- id: 01KY717F5YX377C3GB1T09P1Y5
  author: Steve Vine
  at: 2026-07-23T08:24:46.014294Z
  text: |-
    Steve Vine · 2026-07-05:

    Built as agreed — PR: https://github.com/Steve-vine/notuvia/pull/186

    **What was done**

    - A chevron caret at the far right of every panel header, matching the sidebar sections' design (`CollapsibleSection`): down when open, rotated when folded, `aria-expanded`, same hover treatment as the panel's menu buttons. One shared snippet drives all four panels.
    - Folding hides the body, leaving title + count; the counts stay live since folded panels still load their data.
    - Persistence per-machine in one `notuvia:dashboardCollapsed` localStorage map, like the other dashboard view prefs.

    **Decisions made on the fly**

    - The ToDo panel's filter/sort menus hide while it's folded (menus over a hidden list read as clutter); the caret remains. Say if you'd rather they stay visible.
    - The header row itself isn't a click target — it contains the menu buttons, so nesting a whole-header button isn't possible; the caret is the toggle, exactly as the issue asked.

    **Problems encountered**

    None. Visual pass: caret alignment against the ToDo menus, the folded panel's height/spacing in the stack, and that fold state survives an app restart.
---
Make each section in the Dashboard collapsable down to the title.  Add an expand/collapse button to the far right of the top of each panel, same design as the left and right panel sections.

## Agreed work

* Every Dashboard panel (To Do, Favourites, Recently Created, Recently Updated) gains a chevron toggle at the far right of its header — the sidebar sections' caret design (`CollapsibleSection`): chevron points down when open, rotates when collapsed, `aria-expanded`. The ToDo panel's filter/sort menus stay to its left in the same right-aligned cluster.
* Collapsing hides the panel body, leaving the header (title + count) as the sidebar sections do. The header row itself isn't the click target (it contains the menu buttons); the caret button is — as the issue asks.
* State persists per-machine in one localStorage map (`notuvia:dashboardCollapsed`, panel-id → collapsed), like the board sort / sprint-filter view prefs. Collapsed panels still load their data (cheap local queries; counts stay live in the header).

Checks: `npm run check`, `npm test`.

---

Linear DEV-857 · Dashboard · created 2026-07-05 · done 2026-07-05