---
id: 01M4JD9TPTZPSYCWQ5V5453DGD
created: 2026-10-10T08:01:35.962623Z
updated: 2026-10-10T10:12:17.604931Z
type: task
title: 'Right panel: Initiative section with its projects, and Reference, for a selected initiative'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 524
sprint: sqcp1k3
blocked_by:
- 01M4JD9ASMB7CTMSQ546TNBX2A
- 01M4JCVEM0XB8W3VXFB7VMHD9C
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
So that picking an initiative on the Planner behaves like picking a project: the right panel shows its Properties and Taxonomies, then an **Initiative** section (the Project section's shape with a list of projects instead of sprints, and the eye toggle hiding completed projects), then **Reference** with its linked notes. Today an initiative row in the sidebar drives nothing on the right.

## Agreed work

- [ ] `Main.svelte`: a `boardInitiativeId` beside `boardProjectId` — the initiative behind the current context: the sidebar's per-initiative row (`sel.kind === "projects" && sel.initiative`), or an initiative card selected on the initiatives board (`sel.kind === "initiatives"` + `boardSelectedCardId`); null otherwise. `selectedNoteId` returns it when no card/overlay is selected, so `PropertiesPanel` shows the initiative's Properties and Taxonomies (the same way a scoped project's show today).
- [ ] Fetch, keyed on `boardInitiativeId` + `noteRev`/`taxonomyRev` like the project effect: `initiativeProjects(id)` (already returns status, `is_done`, priority, assignee, dates) and `initiativeMemos(id)` (NOT-523).
- [ ] New `InitiativeSection.svelte` modelled on `ProjectSection.svelte`: title row with the initiative's name as a link (`onOpen` → overlay) and the eye toggle; one row per project — status dot in the status colour, title, identifier chip — done projects greyed (the NOT-392 idiom) and dropped when the toggle is on. The toggle is a per-machine preference, `hideDoneProjects.svelte.ts` on the `hideEmptySprints` pattern, off by default. Clicking a row jumps to that project's task board (`{ kind: "some", ids: new Set([id]) }` via the NOT-521 `selectBoard`); Cmd/Ctrl-click adds it to a multi-project selection, the sidebar's idiom. Collapse state in `KanbanState.initiativeCollapsed`.
- [ ] `ReferenceSection` reused below it with `initiativeMemos`, hidden when empty, sharing `referenceCollapsed`.
- [ ] Both sections render in the Planner's right panel `{#snippet extra()}` next to the project pair, gated so a selection is either a project context or an initiative context, never both.
- [ ] Workspace canvas parity (DEV-915): an Initiative note selected on the canvas shows the same two sections — include if it is the same gate as the project case, otherwise note it as a follow-up.
- [ ] Tests: `tabsStorage.test.ts` for `initiativeCollapsed`; a unit test for the row-shown rule in `hideDoneProjects.svelte.ts`; a `.ts` helper test for `boardInitiativeId`'s cases if extracted.

## Notes

Depends on NOT-523 for the Reference list and on NOT-521 so the jump-to-board path closes any open overlay. The open-task count per project (the sprint rows' chip) is not in `InitiativeProject` — leave the chip off rather than add a per-project task count query; revisit if the list feels bare.