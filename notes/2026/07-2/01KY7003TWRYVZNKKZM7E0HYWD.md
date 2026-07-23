---
id: 01KY7003TWRYVZNKKZM7E0HYWD
created: 2026-07-23T08:03:16.444042Z
updated: 2026-07-23T11:00:29.279975Z
type: task
title: Make the left and right panels individually collapsible
number: 128
imported_from: linear
task_status: done
priority: medium
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sg7px8a
label: null
---
The main window now has three columns: the left sidebar (browse/search), the centre panes, and the right Properties panel (DEV-711). Both side panels are always visible, which is tight on smaller windows.

Make the **left sidebar** and the **right Properties panel** each individually collapsible, so the user can reclaim that space for the centre panes.

Requirements:

* A control to collapse/expand each panel (e.g. a toggle on each panel, and/or a thin rail to expand when collapsed).
* The two are independent — collapsing one doesn't affect the other.
* The collapsed/expanded state of each persists across app restarts (per-machine view preference, like the Kanban column width — localStorage).
* When a panel is collapsed, the centre panes take the freed width.

Follows DEV-711 (Properties panel) and the always-on layout it introduced.

---

Linear DEV-721 · UI Improvements · created 2026-06-29 · done 2026-06-29