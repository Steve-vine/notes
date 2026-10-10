---
id: 01M4JCVEM0XB8W3VXFB7VMHD9C
created: 2026-10-10T07:53:44.832371Z
updated: 2026-10-10T09:44:32.237178Z
type: task
title: 'Planner: a sidebar click lands on the board, not a remembered overlay note'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 521
sprint: sqcp1k3
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Bug. Clicking All / Active / Closed Initiatives sometimes shows the last-viewed initiative's note instead of the initiatives board or timeline.

## Cause

The board overlay is remembered per view (NOT-383) under `viewKeyOf(tab)` in `Main.svelte`, and on the Planner that key is `boardScopeKey(sel)`. `boardScopeKey` folds every scope of a board into one key — `"initiatives"` for All/Active/Closed Initiatives, `"projects"` for the projects equivalents — so:

- opening an initiative card leaves its overlay under `"initiatives"`; clicking Active Initiatives keeps the same key, so the swap effect does nothing and the overlay stays up;
- leaving the Planner with that overlay open stashes it; coming back and clicking All Initiatives restores it — the "sometimes".

The same holds for projects (All/Active/Closed Projects) and any Tasks-section row that keeps its scope key; initiatives just made it visible because the initiative note opens from its card. Nothing in the six sidebar callbacks (`selectInitiativesBoard`, `selectProjectsBoard`, `selectProjectsOf`, `selectAllTasks`, `selectUngrouped`, `selectProject`) closes the overlay — only `openSprintBoard` does.

## Agreed work

- [ ] `Main.svelte`: route every sidebar board selection through one `selectBoard(sel)` that closes the overlay (`closeOverlay()`, `boardSelectedCardId = null`), drops the stash for the destination's overlay key (`overlayByView.delete(...)`) so a stale note is not restored, then sets `active.kanban.sel`. A sidebar row click is a deliberate "show me this board"; NOT-383's restore stays for top-tab and view-mode switches, which don't go through this path.
- [ ] Reuse it in `openSprintBoard`, which hand-rolls the same three lines today.
- [ ] Check `KanbanView.addViaForm` and the Capture `note-saved` path still open the new card's overlay after a board change (they set the overlay after the selection, so should be unaffected — confirm).
- [ ] Test: `boardScope.svelte.test.ts` or a new `Main`-level helper test if the logic is extracted; at minimum a unit test that `selectBoard` clears the stash for the target key.

## Notes

Not a change to `boardScopeKey` — the folded scope key is intentional for sort/filter preferences (NOT-377). The fix is in the selection path, not the key.