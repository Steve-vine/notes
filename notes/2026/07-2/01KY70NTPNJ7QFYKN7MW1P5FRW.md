---
id: 01KY70NTPNJ7QFYKN7MW1P5FRW
created: 2026-07-23T08:15:07.989179Z
updated: 2026-07-23T11:00:30.208338Z
type: task
title: Browser list behaviour
imported_from: null
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 161
comments:
- id: 01KY70P0CW0NJ07KCBR3SKXPYM
  author: Steve Vine
  at: 2026-07-23T08:15:13.820371Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/143

    **What was done:** Added `reloadTree()` in `Main.svelte`: it refetches the root values and every expanded path's children in place, keeping the tab's expanded paths and the caches — so a capture-window save, import, delete, or taxonomy edit updates the tree without folding anything (and without the clear-then-refill flicker). All four note-driven refresh sites plus the taxonomy-registry effect now use it; `refreshBrowseData` (tab switch) reuses it too.

    **Decisions on the fly:** Axis changes (add/remove/reorder/switch a level) deliberately still collapse via `loadRoot()` — the old paths are meaningless under a different nesting order. `loadRoot`'s `keepExpanded` parameter became dead and was removed. I also extended the preserve-expansion behaviour to taxonomy-registry edits (renames/new values), not just note saves — a stale expanded path just fetches quietly to empty, which `fetchChildren` already handled.

    **Problems:** None. `npm run check` and `npm test` green. Worth a hands-on test in review: expand a few levels, save a note from the capture window, watch the tree stay open.
sprint: sg5stzf
label: null
---
When something happens, like creating a new note, that causes the browse list to be updated, all the sections are collapsed down.  This is a pain if you were working on a section nested several levels deep.  This section should be able to update without collapsing sections.

## Agreed work

* Add a `reloadTree()` helper in `Main.svelte` that refreshes the browse tree **in place**: it refetches the root values and the children of every expanded path, without clearing the caches or the tab's `expandedPaths` — so nothing collapses and nothing flickers.
* Use it everywhere the tree refreshes because *notes* changed: after a note is saved from the capture window, after an import, after a delete, and on a taxonomy-registry change.
* Axis changes (add/remove/reorder/switch a level) still reset the tree via `loadRoot()` — the old paths are meaningless there. Tab switches already restore the tab's persisted expansion.
* Stale expanded paths (a value that vanished) already fetch quietly to empty; no new handling needed.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-799 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04