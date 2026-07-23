---
id: 01KY724CAVMX6BHFFNTEWG6BG8
created: 2026-07-23T08:40:33.371176Z
updated: 2026-07-23T11:00:29.988809Z
type: task
title: 'In-panel adding: "+" search picker and create-note-on-canvas'
imported_from: null
comments:
- id: 01KY724KB6YJSMGFAAZ0HCVB39
  author: Steve Vine
  at: 2026-07-23T08:40:40.549911Z
  text: |-
    Steve Vine · 2026-07-09:

    Done — PR [#243](https://github.com/Steve-vine/notuvia/pull/243).

    **What was done:** the agreed plan in full — `AddNotePicker.svelte` (search input over live results: fuzzy `searchNotes` while typing, `recentNotes("updated", 12)` before that, per-type icons, already-present notes checked/disabled, multi-add), the labelled "+ Add note" header button, the canvas context menu split into icon/canvas variants, and "New note here" creating an untitled memo at the click point via a new `createNote` wrapper in `notes.ts` (the capture window's `save_note` shape) then opening it over the canvas. No backend change.

    **Decisions made on the fly:**
    - The picker guards against out-of-order async responses (a slow earlier search can't clobber a newer one).
    - Right-clicks on the "no notes yet" hint text fall through to the canvas (`pointer-events: none`) so "New note here" works anywhere in the empty area.
    - Icon context menus now `stopPropagation()` so the new canvas-level `oncontextmenu` can't double-fire.

    **Problems encountered:** none.

    **Verification:** `vitest run` 151/151, `npm run check` clean. Manual pass: "+ Add note" → recent notes appear instantly, typing filters, adding drops icons at free slots and greys the row; right-click empty canvas → "New note here" → icon at the click point + note opens over the canvas (title it, Esc back, label updates); right-click an icon still shows Open/Remove.
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 260
sprint: sk9rvcx
label: null
---
Add notes without leaving the Workspace view — the round-trip through each note's editor shouldn't be the only route.

**Agreed plan (2026-07-09):**

- [ ] New `AddNotePicker.svelte` (dependency-picker popover pattern): autofocused search input over a live results list — `searchNotes()` as you type, `recentNotes()` when empty; per-type icons and `(untitled)` fallback; notes already on the workspace shown checked/disabled; stays open for multi-add.
- [ ] Header: labelled **"+ Add note"** button in the Workspace tools row (the bare plus icon already means "New Workspace"); `onAdd` places at `firstFreeSlot` and reloads items directly (picker lives in the view — no `bumpNotes` detour needed).
- [ ] Canvas context menu: `menu` state becomes a union (`icon` | `canvas`); right-click on empty canvas (target-guarded) opens a "New note here" entry at the click point.
- [ ] "New note here": `createNote` wrapper in `notes.ts` around the capture window's `save_note` shape → empty untitled memo → `addNoteToWorkspace` at the click point → `bumpNotes()` → opens over the canvas for editing.
- [ ] Empty-workspace copy mentions both routes.

No backend change.

---

Linear DEV-913 · Workspaces · created 2026-07-09 · done 2026-07-09