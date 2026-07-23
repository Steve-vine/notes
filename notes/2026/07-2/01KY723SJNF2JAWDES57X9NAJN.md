---
id: 01KY723SJNF2JAWDES57X9NAJN
created: 2026-07-23T08:40:14.165757Z
updated: 2026-07-23T12:24:59.92683Z
type: task
title: Add note to workspace from the note editor
assignee: steve
label: null
comments:
- id: 01KY7240CMWVXQKPXEK5EQKZAP
  author: Steve Vine
  at: 2026-07-23T08:40:21.139688Z
  text: |-
    Steve Vine · 2026-07-09:

    Done — PR [#242](https://github.com/Steve-vine/notuvia/pull/242).

    **What was done:** the agreed plan in full — the `workspace` statusbar icon, `WorkspacePicker.svelte` popover (workspaces listed with membership checks, click toggles add/remove, stays open for multi-toggle), the `firstFreeSlot` grid helper so adds land in a free top-left slot, `bumpNotes()` after each toggle so an open canvas refreshes live, hidden for trashed notes, errors via the existing notices strip. No backend change.

    **Decisions made on the fly:**
    - The popover drops **downward** (the statusbar is at the top of the pane, not the bottom as I'd first assumed) and right-aligns to the icon.
    - `firstFreeSlot` treats an off-grid, hand-dragged icon as blocking any grid cell within half a step, so a slightly-nudged icon can't be overlapped by a new add.
    - The picker updates its own membership list optimistically in place after each successful call, so multi-toggling several workspaces needs no refetch.

    **Problems encountered:** none.

    **Verification:** 5 new `firstFreeSlot` vitest cases; `vitest run` 151/151; `npm run check` clean. Manual pass for you: open a note → workspace icon → toggle onto a workspace → Workspace tab shows it at a free slot (live if the tab's already open); toggle off removes it; trash the note → picker gone.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 259
sprint: sk9rvcx
---
The note-centric add route from the original DEV-908 description: an icon in the note editor's statusbar that opens a popover listing all workspaces, so the current note can be placed on (or removed from) any of them.

**Agreed plan (2026-07-09):**

- [ ] `workspace` icon in `Icon.svelte` (lucide layout-dashboard style).
- [ ] `firstFreeSlot(items)` helper in `workspaces.ts` (grid scan matching the canvas tile footprint, ~120×110px from (16,16), row-major over 6 virtual columns) + vitest coverage — added notes land in a free top-left slot, not stacked at 0,0.
- [ ] New `WorkspacePicker.svelte`: statusbar anchor+popover (NotePane Insert/Format menu pattern), lists workspaces with a check for ones the note is already on; click toggles membership (add at free slot / remove); stays open for multi-toggle; `bumpNotes()` after each successful toggle so an open Workspace canvas refreshes (the app's own workspaces.yaml write is self-write-suppressed from the watcher, so `noteRev` is the live-update path). Empty state points at the Workspace tab.
- [ ] `NotePane.svelte`: picker slots in the `{#if noteId}` action block after the full-width button; hidden for trashed notes; errors surface via `handle.doc.error` → the existing notices strip. Works for all three note types.

No backend change — membership comes from `listWorkspaces()` and the DEV-911 add/remove commands.

---

Linear DEV-912 · Workspaces · created 2026-07-09 · done 2026-07-09