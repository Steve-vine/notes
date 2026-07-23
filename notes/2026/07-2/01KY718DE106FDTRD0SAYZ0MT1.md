---
id: 01KY718DE106FDTRD0SAYZ0MT1
created: 2026-07-23T08:25:16.993218Z
updated: 2026-07-23T11:00:30.453163Z
type: task
title: Add Dashboard Panels section
assignee: steve
comments:
- id: 01KY718N7GY3MZWC0SCD9B18MX
  author: Steve Vine
  at: 2026-07-23T08:25:24.976154Z
  text: |-
    Steve Vine · 2026-07-05:

    Built as agreed — PR: https://github.com/Steve-vine/notuvia/pull/188

    **What was done**

    - `PanelsSection.svelte` in the right-hand Properties panel while the Dashboard is active: a `CollapsibleSection` titled Panels, one tickbox per panel, ticked = visible.
    - Shared visibility state via a rune module (`dashboardPanels.svelte.ts`) over the per-machine `notuvia:dashboardHidden` map; `PANEL_LABELS` added beside `PANEL_IDS`.
    - The Dashboard renders only visible panels; reorder-while-hidden translates insertion indices onto the full order so hidden panels keep their place. All-unticked shows a hint pointing back at the section.
    - Per-tab section collapse via a new `dashboard: { panelsCollapsed }` workspace slice (old saved workspaces revive with the default).

    **Decisions made on the fly**

    - Hidden panels still load their data (cheap local queries, consistent with folded panels) — they just don't render.
    - The DEV-857 collapse-map storage was generalised into one bool-map helper now that two such maps exist.

    **Problems encountered**

    None. Visual pass: the Panels section's placement in the right pane (it renders above the note properties when a task is open from the dashboard), tickbox hover/spacing against the sidebar row idiom, and reordering with a panel hidden then re-ticking it.
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 206
sprint: sjgxe93
label: null
---
Add a dashboard 'Panels' section on the right hand pane, usual collapsable design. List each panel with a tickbox to make it visible or invisible.

## Agreed work

* New `PanelsSection.svelte` in the right-hand Properties panel, shown while the Dashboard view is active — a `CollapsibleSection` titled **Panels** (the ProjectSection idiom), listing the four panels (To Do, Favourites, Recently Created, Recently Updated) each with a tickbox: ticked = visible.
* Visibility is shared state between the section and the Dashboard: a small rune module (`dashboardPanels.svelte.ts`) over a per-machine map (`notuvia:dashboardHidden`), joining the collapse/order view prefs. Panel labels come from a `PANEL_LABELS` export beside `PANEL_IDS`.
* The Dashboard renders only visible panels; drag-reorder still works with panels hidden (insertion indices translate from the visible list to the full order, so hidden panels keep their place). If everything is unticked, a hint points back at the Panels section.
* The section's collapsed state is per-tab like the other right-panel sections: the workspace tab gains a `dashboard: { panelsCollapsed }` slice (serialize/revive like `kanban`).

Checks: `npm run check`, `npm test`.

---

Linear DEV-859 · Dashboard · created 2026-07-05 · done 2026-07-05