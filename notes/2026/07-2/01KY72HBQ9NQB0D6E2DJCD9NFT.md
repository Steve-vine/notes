---
id: 01KY72HBQ9NQB0D6E2DJCD9NFT
created: 2026-07-23T08:47:38.729683Z
updated: 2026-07-23T11:00:29.394399Z
type: task
title: Project Visualisation - Timeline
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 293
comments:
- id: 01KY72HJPMP3E968XRNYZYV4C4
  author: Steve Vine
  at: 2026-07-23T08:47:45.876033Z
  text: |-
    Steve Vine · 2026-07-12:

    Designed in plan mode with Steve (2026-07-12). Agreed shape: a portfolio Timeline on the Planner tab's Projects board — the switcher generalises to **Kanban | Timeline** — with one row per project: a status-tinted Start/End envelope (tasks-derived when unset) subdivided by **sprint segments** (spans derived from member tasks, the Gantt band rule), % complete chips, drag-to-reschedule the project's dates, and double-click through to that project's Gantt.

    Delivery in two issues here: DEV-955 (skeleton: `timeline_projects` aggregate + read-only chart behind the switcher) → DEV-956 (interactions: drag Start/End, double-click into the Gantt). This issue is the umbrella — closed when both land.
sprint: scnde4j
label: null
---
Add a capability to show projects as a timeline. Flesh this out with me in plan mode and then create the issues in this milestone.

---

Linear DEV-946 · Project Enhancements · created 2026-07-11 · done 2026-07-12