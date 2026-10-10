---
id: 01M4JBWZ3PHRB4046J0X8FJG7W
created: 2026-10-10T07:37:05.910101Z
updated: 2026-10-10T10:07:23.567641Z
type: task
title: 'Planner sidebar: initiative rows under Initiatives, project rows under Projects'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 519
sprint: sqcp1k3
blocked_by:
- 01M4JBWJHXP0TSPG7EZT6WNS30
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
So that each section lists its own kind of note. Today the per-initiative rows sit under Projects (they open an initiative's projects board) and the per-project rows sit under Tasks (they open a project's task board) — the row lives where its board is. The agreed layout moves each list up into the section named for it; what a row opens does not change.

## Agreed layout

```
[Filter] [options] [New note]          ← NOT-517
Initiatives
  All Initiatives
  <one row per initiative>
───
Projects
  All Projects
  <one row per project>
───
Tasks
  All Tasks
  Loose Tasks
```

## Agreed work

- [ ] `KanbanSidebar.svelte`: Initiatives = All Initiatives + the initiative rows (click → that initiative's projects board, `onSelectProjectsOf`); Projects = All Projects + the project rows (click → that project's task board, `onSelectProject`, Cmd/Ctrl-click still multi-selects); Tasks = All Tasks + Loose Tasks only. The in-section `sb-divider` between fixed rows and the list stays; the `---` between sections is the `CollapsibleSection` boundary as now (check whether a visible rule is wanted — Browse has none).
- [ ] Row selection state follows the row: an initiative row is `selected` when `boardSel.kind === "projects" && boardSel.initiative === id`; a project row when `boardSel.kind === "some" && boardSel.ids.has(id)` — unchanged logic, moved.
- [ ] Empty states: "No initiatives" under Initiatives, "No projects" under Projects (the current `sb-empty` sits under Tasks).
- [ ] The row lists honour the NOT-517 filter and toggles wherever they now sit.
- [ ] Update the header comments in `KanbanSidebar.svelte` (DEV-599/763/802, ADR 0070) to describe the new placement, and `brief/ui.md` if it describes the Planner sidebar's sections.
- [ ] Tests: whatever `KanbanSidebar` coverage exists is adjusted; none added if the logic is unchanged.

## Notes

Pure re-arrangement of `KanbanSidebar.svelte` — no board, storage or backend changes. Lands last so it is a small diff on top of NOT-517/518.