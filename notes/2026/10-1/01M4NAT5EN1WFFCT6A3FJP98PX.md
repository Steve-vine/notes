---
id: 01M4NAT5EN1WFFCT6A3FJP98PX
created: 2026-10-11T11:15:48.821919Z
updated: 2026-10-11T12:25:54.45548Z
type: task
title: 'Planner: Roadmap view — Gantt-style chart of a project''s or initiative''s roadmap, before Kanban'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 533
sprint: sn8d5g8
blocked_by:
- 01M4NASAMK50CJKJR5FYVJFH60
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
So that a roadmap can be read as a timeline, not just a list: when the Planner is scoped to a project or to one initiative that has roadmap entries, the view toggle gains a Roadmap option before Kanban — `Roadmap | Kanban | Gantt` for a project, `Roadmap | Kanban | Timeline` for an initiative — showing one row per entry on a date axis. Sprint rows under each entry are the next task.

## Agreed work

- [ ] `tabsStorage.ts`: `KanbanState.view` gains `"roadmap"` (~L51–81), persisted per tab like `"gantt"`.
- [ ] `Main.svelte` view toolbar (~L2224–2251): a "Roadmap" button first in the toggle, rendered only when the scoped note (`scopedProjectId`, or `boardSel.kind === "projects"` with exactly one initiative) has at least one roadmap entry — `note_roadmap(id)` from the commands task, cached per scoped id and refreshed on `notes-changed`. If the scope changes to a note without a roadmap while `view === "roadmap"`, fall back to `"board"`.
- [ ] Render (~L2296–2340): `RoadmapChart` when `view === "roadmap"`, beside the `GanttChart` / `TimelineChart` / `KanbanView` arms.
- [ ] `src/lib/RoadmapChart.svelte`, custom CSS-grid/SVG per ADR 0040, reusing `gantt.ts` (`dayRange`, `monthSegments`, `parseDay`, `isoOf`, `localToday`) and the chart chrome from `GanttChart.svelte` (month header, today line, horizontal scroll): one row per entry in list order; a range entry (`date_mode: range`) is a bar from `start` to `end`; a single entry is a diamond/marker at `start`; the bar or marker takes the kind's `colour`, falling back to the accent; the row label shows the tickbox state (done rows muted/struck), title and kind chip. Entries with no date sit in an "Undated" group under the axis. Range covers all dated entries plus a margin, clamped like the Gantt.
- [ ] Row label click opens the note (the project or initiative) at its Roadmap section via the existing overlay-note path.
- [ ] Empty/edge cases: all entries undated → the axis still renders around today; a range entry with `end < start` is drawn as a single day (core prevents saving it, but old files are read leniently).
- [ ] `brief/ui.md`: the Planner view toggle description, if present.
- [ ] Tests: a pure helper (e.g. `roadmapRows()` in `gantt.ts`) that turns entries + taxonomy into drawable rows, covered in `gantt.test.ts`.

## Notes

No drag-to-reschedule in this task — dates are edited on the note. If that is wanted later it follows `applyDrag` and is a follow-up.