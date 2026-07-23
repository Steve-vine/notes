---
id: 01KY720SNKE9QEXK1CWEF625BK
created: 2026-07-23T08:38:35.955986Z
updated: 2026-07-23T09:08:58.519952Z
type: task
title: Create a Workspace tab
assignee: steve
label: brief
task_status: done
comments:
- id: 01KY72129QZTY0RXGA9YF249Q1
  author: Steve Vine
  at: 2026-07-23T08:38:44.791256Z
  text: |-
    Steve Vine · 2026-07-09:

    Done — PR [#241](https://github.com/Steve-vine/notuvia/pull/241).

    **What was done:** the agreed plan in full — the Workspace view tab, the canvas with per-type icons (new `memo`/`task`/`project` icon paths), pointer-capture drag persisted on drop, title-as-switcher with inline rename, New/Delete with a confirm dialog, the board-overlay for opening notes, per-tab `activeWorkspaceId` persistence, and the `workspace_items` backend enrichment (`Index::notes_by_ids` + runtime method + command) with trashed/dangling ids filtered.

    **Decisions made on the fly:**
    - Esc handling and the Properties panel needed workspace-mode awareness too: Esc leaves-edit-then-closes the overlay exactly as on the board, and the Properties panel shows the overlaid note (like Dashboard).
    - The icon context menu (right-click → Open / Remove from workspace) positions inside the canvas at the click point, accounting for canvas scroll.
    - Clippy pushed `notes_by_ids` from a 4-tuple to a small `NoteMeta` struct in index.rs — nicer anyway.

    **Problems encountered:** svelte-check ignores for the a11y warnings needed comma-separated codes (space-separated silently applied only partially); fixed, 0 warnings.

    **Verification:** cargo workspace tests all green (3 new: enrichment, trashed-hidden-until-restore with position kept, dangling skipped); clippy clean; vitest 146/146 (new round-trip coverage for the tab slice); svelte-check clean.

    **Manual pass needed (I can't drive the UI):**
    1. Workspace tab appears; create → drops into rename; rename/switch via the title; delete confirms and `workspaces.yaml` updates each time.
    2. Hand-add an item to `workspaces.yaml` while running → icon hot-reloads in; drag it → position persists on drop and survives restart.
    3. Double-click → note opens over the canvas; X/Esc returns. Trash the note → icon disappears; restore → back at its old spot.
    4. Tab persistence: restart remembers mode=workspace and the active workspace.
- id: 01KY7216K9AW3W8401P27BC0QE
  author: Steve Vine
  at: 2026-07-23T08:38:49.193445Z
  text: |-
    Steve Vine · 2026-07-09:

    Defect found during DEV-912's manual pass: the canvas rendered zero-height, clipping all icons — `.panes` in Main is a plain block (children size themselves, e.g. Dashboard's `height: 100%`), so WorkspaceView's `flex: 1` was a no-op and the absolutely-positioned icons contributed no height. Fixed with `height: 100%` on the workspace root; landed on the open DEV-912 branch (PR #242, commit e5b5739) rather than a separate PR since it blocked that review.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 255
---
The core Workspace view: a fourth tab alongside Dashboard, Browse and Kanban — a desktop-style canvas where notes appear as icons (name below) and are dragged into position to organise and group them in a single view. Multiple workspaces exist and are switchable.

**Agreed design (fleshed out 2026-07-09):**

* Workspaces are vault data in `workspaces.yaml` (DEV-911, ADR 0035); this brief is the UI plus one enrichment command over those.
* Switching: the editable workspace title at top-left (styled like a note title) doubles as the switcher — a chevron next to it opens a popover listing all workspaces; double-click renames inline.
* 'New Workspace' (plus) and 'Delete Workspace' (trash) icons at the top right of the panel. Delete confirms via an inline dialog and never touches the notes themselves.
* Per-type icons for Memo / Task / Project (new lucide-style paths in `Icon.svelte`).
* Single-click selects an icon, pointer-capture drag repositions it (persisted once on drop via `set_workspace_item_position`), double-click opens the note over the canvas using the existing Kanban board-overlay pattern (X returns to the canvas untouched). Right-click menu / Delete key removes an icon from the workspace (membership only).

**Agreed plan (2026-07-09):**

- [ ] Backend enrichment: `Index::notes_by_ids` batched query; `workspace_items(workspace_id)` runtime method + async Tauri command returning `{note_id, x, y, title, note_type}` with trashed/dangling ids filtered out (they stay in the file — restore brings the icon back). Tests: trashed excluded, restored reappears, unknown id skipped.
- [ ] `tabsStorage.ts`: `"workspace"` added to `ViewMode`/`reviveMode`; per-tab `WorkspaceViewState { activeWorkspaceId }` slice (default/serialize/revive + round-trip test).
- [ ] `ViewTabs.svelte`: fourth "Workspace" button.
- [ ] New `WorkspaceView.svelte`: self-contained data owner (lists + items), header row (title/switcher/rename left; new/delete right), absolute-positioned icon canvas with pointer-capture drag, empty states, freshness via `workspaces-changed` listener + `noteRev()` effect.
- [ ] `Main.svelte`: route the new mode, reuse the board overlay for opening notes, no sidebar sections in workspace mode (like Dashboard).

**Out of scope (separate briefs):** adding notes from the note editor (DEV-912), in-panel "+" picker and create-on-canvas (DEV-913), drag-in from browse/search (DEV-914). Until those land, items get onto a canvas by hand-editing `workspaces.yaml` (hot-reloads) — noted for testing.

---

Linear DEV-908 · Workspaces · created 2026-07-09 · done 2026-07-09