---
id: 01M4NATFJG6H3DKTPNZEXBME2K
created: 2026-10-11T11:15:59.184947Z
updated: 2026-10-11T11:16:18.708402Z
type: task
title: 'Planner: Roadmap view — sprint bars under each entry, project and initiative scopes'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 534
sprint: sn8d5g8
blocked_by:
- 01M4NASP2ZMB39TBKJSZ0AZH9Z
- 01M4NAT5EN1WFFCT6A3FJP98PX
assignee: steve
label:
- feature
priority: medium
task_status: backlog
tech: null
---
So that the Roadmap view shows not only when an entry is due but which sprints deliver it: each entry row expands to show its associated sprints as scheduled bars, using the same sprint scheduling and slippage colouring as the Gantt and Timeline, on both a project scope and an initiative scope.

## Agreed work

- [ ] `RoadmapChart.svelte`: an expand/collapse chevron on entry rows that have sprint refs (state persisted per tab, as sprint bands are in the Gantt). Expanded, one sub-row per associated sprint: label "Sprint title" (project → "Project · Sprint" on an initiative), a bar from `sprintSchedule` (`gantt.ts` ~L194) coloured by `sprintState` (~L219: done / late / normal), and done/total on the right.
- [ ] Data: project scope → the project's `sprints` (already in `timeline_projects` / `projectSprints`) and `project_sprint_progress`; initiative scope → the same per member project referenced by any entry. Fetch lazily on first expand, refresh on `notes-changed`.
- [ ] Sprint sub-row click opens that sprint's task board (`openSprintBoard`, `Main.svelte` ~L739), matching the "N tasks" buttons on the note.
- [ ] Initiative scope end-to-end: the Roadmap button appears for a single-initiative projects board, the chart draws the initiative's entries, and sprint sub-rows resolve across member projects. Multi-initiative selections and the all-projects board show no Roadmap button.
- [ ] Tests: the sub-row derivation helper in `gantt.test.ts`.

## Notes

Lands last: small diff on top of the chart and the sprint-association tasks. An in-app pass over the whole sprint is worth doing after this merges — the Initiatives sprint shipped largely unseen.