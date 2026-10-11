---
id: 01M4NATFJG6H3DKTPNZEXBME2K
created: 2026-10-11T11:15:59.184947Z
updated: 2026-10-11T12:38:33.699023Z
type: task
title: 'Planner: Roadmap view — sprint bars under each entry, project and initiative scopes'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 534
sprint: sn8d5g8
blocked_by:
- 01M4NASP2ZMB39TBKJSZ0AZH9Z
- 01M4NAT5EN1WFFCT6A3FJP98PX
comments:
- id: 01M4NFHNAJPQEB8EDJJYX54A5V
  author: Steve Vine
  at: 2026-10-11T12:38:33.041699Z
  text: |-
    Built and merged (squash, PR #525), CI green. The branch is deleted. This closes the Roadmaps sprint.

    What landed:
    - RoadmapChart: an entry with linked sprints gets the Timeline's rail caret; unfolded, one row per sprint ("Project · Sprint" on an initiative) with a done/total chip and the Timeline's segment over the sprint's scheduled slot, filled to its done %, green when done, red when slipping. Row and bar click → `openSprintBoard` (the note's "N tasks" jump). Expansion is component-local like the Timeline's.
    - Data from `timeline_projects` + `defaultSprintDuration`: the project itself, or every member project an entry's refs name, with slots resolved the Timeline's way. Linked sprints' slots widen the range so they are always in view.
    - roadmap.ts: `RoadmapSprintPool` and `roadmapSprintBars` (soonest slot first; a slotless sprint keeps its row with no bar).
    - brief/ui.md: the sprint rows described under the Roadmap paragraph.

    Decided on the fly: slots/tallies come from the existing `timeline_projects` aggregate rather than per-project `project_sprint_progress` + `projectSprints` calls — one fetch, and it already carries `plan_start` / `plan_days` / `latest_open` for the late state. Expansion isn't persisted per tab (the Timeline's isn't either).

    Verification: npm check 0 errors, npm test 610 passed, npm build ok. No Rust changes. Not run in the app — the whole sprint (NOT-528..534) needs an in-app pass: Settings → Roadmap Entries, the note section on a project and an initiative, and the Planner Roadmap leg on both scopes.
assignee: steve
label:
- feature
priority: medium
task_status: done
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