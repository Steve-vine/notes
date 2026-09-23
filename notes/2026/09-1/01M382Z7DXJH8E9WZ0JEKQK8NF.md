---
id: 01M382Z7DXJH8E9WZ0JEKQK8NF
created: 2026-09-23T21:32:56.637694Z
updated: 2026-09-23T21:50:35.001266Z
type: task
title: 'UI redesign: shell — icon rail, overlay title bar, tab strip, lines not gaps'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 430
sprint: sqsolof
assignee: steve
label:
- improvement
priority: medium
task_status: active
tech: null
---
- Icon rail on the far left replaces the ViewTabs strip: six view icons (Browser, Search, Planner, Workspace, Dashboard, Schedules), keeping per-tab view state and view reordering. No N brand mark.
- Theme toggle and settings cog at the bottom of the rail.
- Overlay title bar on macOS with the tab strip restyled around the traffic lights (borderless chips, active tab in pane colour, number chips, × on the active tab); plain fallback on Windows/Linux.
- Panels separated by 1px lines; note pane full-bleed instead of rounded grey panels with gaps.
- Panel resizing (180–480) and collapse persistence kept.