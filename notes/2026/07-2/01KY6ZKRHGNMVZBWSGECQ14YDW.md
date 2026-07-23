---
id: 01KY6ZKRHGNMVZBWSGECQ14YDW
created: 2026-07-23T07:56:31.664444Z
updated: 2026-07-23T11:03:34.605844Z
type: task
title: Project Visualisation - Gantt Chart
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 104
comments:
- id: 01KY6ZKY77057761A3C7SJND9G
  author: Steve Vine
  at: 2026-07-23T07:56:37.4787Z
  text: |-
    Steve Vine · 2026-07-11:

    Designed in plan mode with Steve (2026-07-11). Agreed shape: tasks grouped under sprint bands; a new `start` core date field (bar = start → due, due-only tasks as a point, dateless tasks in an Unscheduled list); a Board ⇄ Gantt toggle on the project-scoped Kanban view; sprints stay dateless (bands derive their span from member tasks) with % complete chips; projects get Start/End (End = the existing due field).

    Delivery is split into five PR-sized issues in this milestone, in dependency order:

    1. DEV-948 — Start dates on tasks and projects (ADR 0040 lands here)
    2. DEV-949 — Gantt view skeleton (toggle + read-only chart, today line, weekend shading, sprint bands + % complete, project envelope)
    3. DEV-950 — Gantt zoom levels
    4. DEV-951 — Drag to reschedule (`set_note_dates`, ghost-mirror sync)
    5. DEV-952 — Dependency arrows (+ blocker-conflict highlight)

    This issue is the umbrella — it closes when all five land.
sprint: scnde4j
---
Add a capability to show projects as Gantt charts.  Flesh this out with me in plan mode and then create the issues in this milestone.

---

Linear DEV-685 · Project Enhancements · created 2026-06-27 · done 2026-07-12