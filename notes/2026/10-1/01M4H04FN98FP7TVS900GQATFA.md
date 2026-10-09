---
id: 01M4H04FN98FP7TVS900GQATFA
created: 2026-10-09T18:52:14.889205Z
updated: 2026-10-09T21:46:15.759671Z
type: task
title: 'Planner: Initiatives section and board'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 514
sprint: sqcp1k3
blocked_by:
- 01M4H045JSJANCCPDDYH5N9RSE
assignee: steve
label:
- feature
priority: high
task_status: active
tech: null
---
So that initiatives are managed from the Planner tab the way projects are: a new Initiatives section above Projects in the left sidebar, selecting an initiatives kanban board whose "+" creates an initiative. Builds on the frontend plumbing task.

## Agreed work

- [ ] `KanbanSidebar.svelte`: a new collapsible "Initiatives" section above "Projects" with All / Active / Closed Initiatives rows, mirroring the Projects section's three scoped rows.
- [ ] `board.ts`: a new `BoardSel` kind `{kind: "initiatives", scope?}`; `Main.svelte` gets `initiatives` state, `loadInitiatives()` reloaded on `noteRev`, `selectInitiativesBoard`, and the sidebar wiring.
- [ ] `KanbanView.svelte`: an `initiativesView` branch alongside `projectsView` — status axis `initiative_status`, column reorder, card chips (priority / assignee), and `addViaForm` opening the capture form with `{type: "initiative", status}`.
- [ ] Projects section lists one row per initiative (plus "Loose Projects") below its All / Active / Closed rows, the way the Tasks section lists projects, so the project board can be scoped to an initiative; `taskBoard`-style scoping for projects by initiative ids.
- [ ] `tabsStorage.ts`: persist the new selection kind and an `initiativesCollapsed` flag; a saved Initiatives tab survives a restart; old documents without the flag revive cleanly.
- [ ] Right panel when an initiative board card or row is selected: `ProjectSection`-style summary showing the initiative's projects with status dots.
- [ ] Tests: `tabsStorage.test.ts` for the new kind and revive, `boardScope.svelte.test.ts` for initiative-scoped project boards.

## Notes

Restyle nothing else — the section is a copy of Projects with a different list behind it. Layout checked in the UI lab with headless Chrome (dark and light, narrow width); the live Planner needs a pass from Steve.