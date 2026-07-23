---
id: 01KY72PBVM8ZSMHM8KFD3DNB5Q
created: 2026-07-23T08:50:22.708449Z
updated: 2026-07-23T08:50:22.708449Z
type: task
title: Timeline skeleton — projects as sprint-segmented bars
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 302
---
Part 1 of the Timeline (DEV-946). On the Planner tab's **Projects board**, the switcher generalises to **Kanban | Timeline** (same anchored position, same per-tab `KanbanState.view`): one row per live project, ordered by effective start.

* New aggregate command `timeline_projects()`: per project — id/title/identifier, raw start/due, resolved `project_status` (label/colour/is_done), done/total task counts (DEV-831 rule), and each sprint's derived span (min start/due → max due over member tasks) + done/total. Built from existing pieces (`child_tasks`, `parse_sprints`, `taxonomy_value_by_note`); no index change.
* `TimelineChart.svelte`, read-only: status-tinted envelope line (Start/End, tasks-derived fallback) with **sprint segments** as boxes on the row (S1…Sn labels when wide enough, Sprint-0 segment for unassigned tasks), % complete chip in the rail, `project_status` legend, Unscheduled strip for dateless projects, select-on-click. Reuses `gantt.ts` helpers and the Gantt's chrome idioms (header, today line, weekend shading, fill-to-pane, shared zoom).
* Core tests for the aggregate; `brief/ui.md` update.

---

Linear DEV-955 · Project Enhancements · created 2026-07-12 · done 2026-07-12