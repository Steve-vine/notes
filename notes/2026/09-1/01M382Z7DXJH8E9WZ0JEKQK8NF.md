---
id: 01M382Z7DXJH8E9WZ0JEKQK8NF
created: 2026-09-23T21:32:56.637694Z
updated: 2026-09-24T18:07:46.465259Z
type: task
title: 'UI redesign: shell — icon rail, overlay title bar, tab strip, lines not gaps'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 430
sprint: sqsolof
comments:
- id: 01M387V0R414HPQYW8P7P8AWPG
  author: Steve Vine
  at: 2026-09-23T22:58:01.604364Z
  text: 'PR #433 open: https://github.com/Steve-vine/notuvia/pull/433 — ViewRail replaces ViewTabs, tab strip as overlay title bar (macOS), view toolbar for board controls, 1px dividers, full-bleed panes. Checks/tests/build green; rail + strip verified in a headless-Chrome mock shell. Needs a real-window check of the traffic-light placement and the strip drag region.'
assignee: steve
label:
- improvement
priority: medium
task_status: done
tech: null
---
- Icon rail on the far left replaces the ViewTabs strip: six view icons (Browser, Search, Planner, Workspace, Dashboard, Schedules), keeping per-tab view state and view reordering. No N brand mark.
- Theme toggle and settings cog at the bottom of the rail.
- Overlay title bar on macOS with the tab strip restyled around the traffic lights (borderless chips, active tab in pane colour, number chips, × on the active tab); plain fallback on Windows/Linux.
- Panels separated by 1px lines; note pane full-bleed instead of rounded grey panels with gaps.
- Panel resizing (180–480) and collapse persistence kept.