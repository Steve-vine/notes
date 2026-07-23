---
id: 01KY6Y51J31GVBGKGRNJT5EBET
created: 2026-07-23T07:31:00.803174Z
updated: 2026-07-23T07:31:10.313931Z
type: task
title: Incremental file-watch index reconcile
task_status: done
label: follow_up
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 13
comments:
- id: 01KY6Y5AV9FZA57MHDFJCMZMAD
  author: Steve Vine
  at: 2026-07-23T07:31:10.313446Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done**
    - **`index.rs`:** WAL + busy-timeout in `open` (watcher writer + reader connections coexist). New `remove_note`, `upsert_note`, `reconcile_path(path)` — id recovered from the `<id>.md` filename (deletes work without the file), unparseable note → removed (matches rebuild), edges *to* a note left dangling (ADR 0006).
    - **`watcher.rs` (`pub mod watcher`):** `VaultWatcher::start(vault)` owns its own `Index`, watches `notes/` recursively via `notify-debouncer-full` (400 ms debounce), reconciles affected paths on events; drop = stop. Watching `notes/` only avoids a feedback loop from `.notula/` writes.

    **Verification** — verbatim CI commands pass: fmt, clippy `-D warnings`, `cargo test` (**29 lib tests**, 4 new), `npm run tauri build`. Headline test: **reconcile == full rebuild** (apply add/edit/delete/malformed via `reconcile_path`, assert the index row-dump equals a fresh `rebuild`). Plus delete/malformed per-op tests and a **live watcher smoke test** (separate reader connection, tolerant ~10 s poll).

    **Decisions / notes**
    - Watcher owns its own connection (WAL), no shared mutex — per planning.
    - **App start-up wiring deferred to M3/M4** (no live index consumer yet), consistent with the other backend-only briefs. Lifecycle documented: `open` → `rebuild` → `start`.
    - Process note: first compile failed — `notify` is only re-exported via `notify-debouncer-full` (used `notify_debouncer_full::notify::…`); a `| tail && echo` had masked clippy's exit code, fixed my check.

    **Scope guard:** only the `project` edge; no IPC/UI. No new ADR (implements ADR 0003).

    **PR:** https://github.com/Steve-vine/notula/pull/13 · commit `538112a`
    This closes the last open M2 issue.
---
Split out from DEV-484. Adds incremental index reconcile (the full rebuild remains the guarantee).

**Checklist**

- [ ] Watch the vault `notes/` tree for create/modify/delete (`notify-debouncer-full`), with debounce
- [ ] On change: re-parse the affected file and upsert/delete its rows in `notes`, `note_values`, `edges`, `notes_fts`
- [ ] Handle deletes (file removed → remove its rows) and moves
- [ ] Reconcile is an optimisation; full rebuild (DEV-484) remains the guarantee
- [ ] Decide threading/ownership of the `rusqlite::Connection`

**Done when:** editing/adding/deleting a note file externally updates the index incrementally, matching what a full rebuild would produce.

---

### Agreed approach (planned 2026-06-19)

* **Threading:** watcher owns its **own** Connection; app reads via a separate connection; **WAL** + busy-timeout. No shared mutex.
* **Scope:** reconcile primitives + `VaultWatcher` library, fully tested; **app start-up deferred** to M3/M4 (no live index consumer yet).
* `index.rs`**:** WAL in `open`; `remove_note` (deletes rows; edges `src=id` only, leaving dangling task→project per ADR 0006), `upsert_note`, `reconcile_path(path)` (id from `<id>.md` filename; exists→parse→upsert, parse-fail→remove, absent→remove).
* **New** `watcher.rs` (`pub mod`): `VaultWatcher::start(vault)` opens its own `Index`, watches `notes/` recursively, reconciles affected paths on debounced events; holds the debouncer alive.
* **Tests:** deterministic "reconcile == rebuild" sequence (Index dump compare) + per-op + one tolerant watcher smoke test via a separate reader connection.

**Scope guard:** no app wiring/IPC/UI; only `project` edge. No new ADR (implements ADR 0003).

---

Linear DEV-508 · M2 — Storage & file handling · created 2026-06-19 · done 2026-06-19