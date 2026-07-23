---
id: 01KY72519N9AGHCJ3F3FC1GETC
created: 2026-07-23T08:40:54.837798Z
updated: 2026-07-23T11:00:29.994481Z
type: task
title: Drag notes from browse/search results onto the workspace canvas
imported_from: null
task_status: done
comments:
- id: 01KY72592A4CRTQESV2H4Q9BRD
  author: Steve Vine
  at: 2026-07-23T08:41:02.79389Z
  text: |-
    Steve Vine · 2026-07-09:

    Done — PR [#244](https://github.com/Steve-vine/notuvia/pull/244).

    **What was done:** the agreed plan in full — the Workspace-mode sidebar (new `WorkspacesSection.svelte` selectable list + the existing Search section, per your design), draggable search rows carrying a custom `application/x-notuvia-note` dataTransfer type, the gated canvas drop target with an accent tint, drop-at-cursor placement (icon centred, clamped), move-not-duplicate for notes already on the workspace, `workspacesRev` for sidebar freshness across in-app create/rename/delete, and the persisted `workspacesCollapsed` tab field.

    **Decisions made on the fly:**
    - Add and move share one code path: the DEV-911 backend's `add_note_to_workspace` already repositions an existing item instead of duplicating, so the drop handler is a single call either way.
    - `dragleave` ignores events fired when crossing into canvas children (checks `relatedTarget` containment), so the tint doesn't flicker while dragging over icons.
    - The sidebar's selected highlight mirrors the view's first-workspace fallback, so a fresh tab (null selection) still highlights the workspace actually shown.

    **Deviation from the original issue text:** Browse-tree rows are not draggable — the canvas isn't visible in Browse mode, so there'd be nowhere to drop; the workspace-mode sidebar is the drag source per the refined design.

    **Problems encountered:** none.

    **Verification:** `vitest run` 152/152, `npm run check` clean. Manual pass: Workspace tab → sidebar shows Workspaces + Search; clicking a workspace switches the canvas and tracks the header switcher (and vice versa, including create/rename/delete); drag a search hit onto the canvas → tint, icon lands under the cursor; drag one that's already there → it moves; release a drag over the sidebar or a note pane → nothing happens.

    This closes out the Create Workspaces milestone once merged. 🎉
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 261
sprint: sk9rvcx
label: null
---
The most direct add route: drag a note from the left sidebar onto the Workspace canvas at the drop position.

**Agreed plan (2026-07-09, refined with Steve):** the Workspace-mode sidebar (currently empty) gains a new **Workspaces** section — a selectable list of workspaces — with the **Search** section below it as the drag source.

- [ ] `workspacesRev.svelte.ts` (noteRev twin): the app's own `workspaces.yaml` writes are watcher-suppressed, so create/rename/delete in the view bump this and the sidebar list refetches.
- [ ] New `WorkspacesSection.svelte`: self-contained workspace list (`listWorkspaces`, refetch on rev + `workspaces-changed`), rows with the workspace icon, selected highlight, `onSelect` writes the tab's `activeWorkspaceId`. Collapsed state persisted per tab (`workspacesCollapsed` added to the `WorkspaceViewState` slice).
- [ ] Main: workspace-mode sidebar renders WorkspacesSection + the existing SearchSection (per-tab `browse` slice exists on every tab); search-run/refresh guards relaxed to include workspace mode.
- [ ] Drag source: SearchSection result rows `draggable` — `dataTransfer` carries the note id as `text/plain` plus a custom `application/x-notuvia-note` type so only real note drags light up the canvas.
- [ ] Drop target: canvas `dragover` tint (custom-type-gated), drop adds at the pointer (icon centred, clamped ≥0); a note already on the workspace **moves** instead of duplicating. No behaviour change for drags ending elsewhere.

**Deviation from the original text:** Browse-tree rows are not made draggable — in Browse mode the canvas isn't visible, so there's nowhere to drop; the workspace-mode sidebar is the drag source per the agreed design.

No backend change.

---

Linear DEV-914 · Workspaces · created 2026-07-09 · done 2026-07-09