---
id: 01M4H04FN98FP7TVS900GQATFA
created: 2026-10-09T18:52:14.889205Z
updated: 2026-10-09T21:53:36.17112Z
type: task
title: 'Planner: Initiatives section and board'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 514
sprint: sqcp1k3
blocked_by:
- 01M4H045JSJANCCPDDYH5N9RSE
comments:
- id: 01M4HAGHXBYGRE3PS1915HS37E
  author: Steve Vine
  at: 2026-10-09T21:53:36.17063Z
  text: |-
    Built and merged (squash, PR #497), CI green. The branch is deleted.

    What landed:
    - Sidebar: an Initiatives section above Projects (All / Active / Closed) selecting the initiatives board; the Projects section gains one row per initiative narrowing the projects board to that initiative's projects.
    - Board: initiativesView beside projectsView, one statusAxisId driving hidden columns, drag-to-restatus, column reorder and the status chip; "+" opens a new Initiative, or a new Project pre-linked to the initiative on a per-initiative board.
    - Selection: BoardSel gains `initiatives` and an `initiative` narrowing on `projects`; isStatusBoard() hides the task-only toolbar controls; a per-initiative projects board gets its own preference scope.
    - Tab storage: serializeSel / reviveSel for the new kinds; initiativesCollapsed persists; pre-initiative documents revive unchanged.

    Deferred (not built): the "Loose Projects" row — needs project cards to carry their initiative, a backend change — and the right-panel summary for a selected initiative card; the initiative note's own project list (NOT-515) covers the read, and a right-panel section can follow if wanted. The per-initiative narrowing is client-side over the vault-wide projects board.

    Verification: npm run check 0 errors, npm test 536/536 (new tabsStorage round-trip and boardScopeKey cases). Not run in the app — the live Planner needs a pass from Steve.
assignee: steve
label:
- feature
priority: high
task_status: done
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