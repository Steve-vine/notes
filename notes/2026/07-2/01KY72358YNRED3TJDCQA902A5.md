---
id: 01KY72358YNRED3TJDCQA902A5
created: 2026-07-23T08:39:53.374899Z
updated: 2026-07-23T09:08:58.534864Z
type: task
title: 'Backend: workspace store in notuvia-core (workspaces.yaml + Tauri commands)'
label: brief
assignee: steve
comments:
- id: 01KY723CCJZ6MS7J3ZSNSJE7ME
  author: Steve Vine
  at: 2026-07-23T08:40:00.658244Z
  text: |-
    Steve Vine · 2026-07-09:

    Done — PR [#240](https://github.com/Steve-vine/notuvia/pull/240).

    **What was done:** the agreed plan in full — ADR 0035 (workspace storage), `workspace.rs` in notuvia-core (registry, lenient load, atomic save), runtime wiring with self-write suppression and `reload_workspaces()`, watcher support for `workspaces.yaml` on the existing non-recursive root watch with a `workspaces-changed` Tauri event, the seven async Tauri commands, purge cascade in `delete_one`, and the `src/lib/workspaces.ts` frontend wrapper. No index/schema change, so no `SCHEMA_VERSION` bump.

    **Decisions made on the fly:**
    - `add_note_to_workspace` validates the note id parses as a ULID and its file exists on disk (trashed is fine) — a workspace can't accumulate references to notes that never existed.
    - The purge cascade is best-effort like attachment cleanup: if the workspaces save fails mid-purge the note deletion still succeeds (the dangling reference is harmless and self-heals on the next save); the error is logged.
    - `VaultRuntime::start` and `VaultWatcher::start` gained a third callback parameter, so all call sites were touched: the MCP server passes a no-op (workspaces aren't exposed over MCP), test fixtures likewise.

    **Problems encountered:** none.

    **Verification:** 15 new tests (registry parse/round-trip, runtime CRUD persisting to the file, purge-vs-trash cascade, external-edit reload, watcher self-write suppression); full `cargo test --workspace` green (306 tests), clippy clean, `npm run check` clean. Worth an in-app smoke test once DEV-908 lands UI over it — until then the commands are only reachable from devtools.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 258
---
The vault-side engine for user-facing Workspaces (desktop-style canvases of note icons). Agreed design: workspaces are **vault data, not machine preferences** — stored in a `workspaces.yaml` at the vault root, following the `taxonomies.yaml` pattern (plain file you own, git-synced, hot-reloaded on external edit). The workspace file owns membership and layout; note files are untouched, so a note can appear in several workspaces at different positions.

**Data model (per workspace):** `id` (ULID), `name`, `items: [{note_id, x, y}]` (f64 coords).

**Agreed plan (2026-07-09):**

- [ ] ADR 0035 — workspace storage: vault-root `workspaces.yaml`, workspace-owned membership/positions (not note frontmatter), per-machine storage rejected; hot-reload + git-sync via the taxonomies.yaml precedent (ADR 0009).
- [ ] `notuvia-core/src/workspace.rs` (template: `taxonomy.rs`): `WorkspaceRegistry::load(vault) -> (Self, Vec<String>)` — missing file ⇒ empty registry (no bootstrap seeding), lenient parse with warnings; atomic save (`.tmp` + rename, `serde_yaml_ng`).
- [ ] Runtime wiring: `workspaces` field on `VaultRuntime`, mutating methods save + record self-write hash under `"workspaces.yaml"` in the watcher's `SelfWrites`; `reload_workspaces()`.
- [ ] Watcher: `on_workspaces_changed` callback (root watch already non-recursive over the vault root); runtime callback reloads + emits `"workspaces-changed"` Tauri event.
- [ ] Tauri commands, all `#[tauri::command(async)]` (ADR 0033): `list_workspaces`, `create_workspace`, `rename_workspace`, `delete_workspace`, `add_note_to_workspace`, `remove_note_from_workspace`, `set_workspace_item_position`.
- [ ] Purge cleanup in `delete_one` (after `attachment::remove_all`): strip items for the purged note, save if changed. Trashed-not-purged notes stay in the file; the UI hides them so restore puts the icon back.
- [ ] Frontend wrapper `src/lib/workspaces.ts` (board.ts conventions) + TS types. No UI — DEV-908 consumes it.
- [ ] No SQLite schema change / no `SCHEMA_VERSION` bump (workspaces aren't indexed).

**Tests:** YAML round-trip, missing/malformed file handling, CRUD through `VaultRuntime`, purge cascade, external-edit reload (tempdir + `vault::bootstrap` fixtures).

Independent of DEV-910; **blocks** DEV-908.

---

Linear DEV-911 · Workspaces · created 2026-07-09 · done 2026-07-09