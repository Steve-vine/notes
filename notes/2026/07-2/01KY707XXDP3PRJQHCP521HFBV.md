---
id: 01KY707XXDP3PRJQHCP521HFBV
created: 2026-07-23T08:07:32.525024Z
updated: 2026-07-23T08:07:43.68979Z
type: task
title: 'Workspace tabs: store, tab strip, per-tab view state'
assignee: steve
label: brief
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 141
comments:
- id: 01KY7088T9KNK6SVSGYDS58DJ4
  author: Steve Vine
  at: 2026-07-23T08:07:43.689374Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/126

    **What was done**
    - Split the work into a pure layer + a rune store: `workspaceStorage.ts` (types, versioned `notuvia:workspace` serialization, defensive per-field revival, legacy `notuvia:paneTree` migration — 8 unit tests) and `workspace.svelte.ts` (module rune store with `add/close/select/rename/cycle`, debounced deep-tracking persist via `$effect.root`, legacy key deleted only after the new document writes).
    - `WorkspaceTabs.svelte`: click switch, dblclick rename, × close (hidden on last tab), + add.
    - Main rewired to `workspace.active` for all view state; sidebar sections and center view keyed on the active tab id — background tabs keep state, unmount DOM (noteDocs flush-on-release makes this lossless). Tab switches rebuild transient data from persisted inputs: rerun search, reload values, re-open expanded folders.
    - Keymap actions `newTab` (Alt+T), `nextTab` (Alt+]), `prevTab` (Alt+[) — remappable, auto-listed in Settings, documented in brief/ui.md.

    **Decisions made on the fly**
    - `editingLeaves` is deliberately **not** persisted (restart always reopens panes in Read mode, matching pre-tab behaviour); it still survives tab switches in memory.
    - Browse expansion: refresh paths (axis change, imports, registry bumps) still collapse the tree exactly as today; only tab activation restores the persisted expansion list — `loadValues(keepExpanded)` + `restoreExpanded()`. Stale persisted values degrade to collapsed.
    - Duplicate tab ids in a hand-edited document are re-minted on revival rather than rejected (keyed rendering would break otherwise).
    - ViewMode type moved from ViewTabs.svelte to workspaceStorage.ts (as trailed in the DEV-763 write-up).

    **Problems encountered**
    - None; svelte-check 0 errors, vitest 102/102, pre-push gate fully green. Same screenshot limitation as DEV-763 — the review pass should cover: tab add/rename/switch/close; per-tab mode/layout surviving switch + restart; first-launch migration of the old layout; typing in a note, switching tabs and back, nothing lost; the three new shortcuts.
---
R4 of the Revamp UI milestone (parent DEV-754). Implements ADR 0021.

* New `workspace.svelte.ts` rune store: `WorkspaceTab { id, name, mode, browse {query, axes, valueFilter, expandedPaths, sectionCollapse}, kanban {sel, sectionCollapse}, paneTree, activeLeafId, editingLeaves, lastOpened }`; mutators wrap the pure `paneTree.ts` helpers; debounced persist.
* Persistence: single versioned `notuvia:workspace` key; one-shot migration from legacy `notuvia:paneTree` (delete legacy key after successful write); defensive revive per field.
* New `WorkspaceTabs.svelte` strip at the top of the window: add ("+"), switch, close, double-click rename.
* Main rewired: keyboard dispatcher and all view state read `workspace.active`; only the active tab's sidebar/center render (background tabs keep state, unmount DOM — noteDocs flushes on release).
* Optional: `nextTab`/`prevTab`/`newTab` keymap actions.

Depends on: DEV-763 (R3).

Checklist:

- [ ] Store + migration (legacy layout preserved into tab 1)
- [ ] Tab strip add/switch/close/rename
- [ ] Per-tab mode, pane tree, browse & kanban state survive switching and restart
- [ ] Editing in a tab, switching away and back loses nothing

---

Linear DEV-764 · Revamp UI · created 2026-07-02 · done 2026-07-02