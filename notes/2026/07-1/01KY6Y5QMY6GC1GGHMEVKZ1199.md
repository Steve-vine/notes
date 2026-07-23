---
id: 01KY6Y5QMY6GC1GGHMEVKZ1199
created: 2026-07-23T07:31:23.422245Z
updated: 2026-07-23T11:03:34.333077Z
type: task
title: Wire index + watcher into app; save_note command
task_status: done
comments:
- id: 01KY6Y61EYEDPRME0805FT376N
  author: Steve Vine
  at: 2026-07-23T07:31:33.46988Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done** — new `src-tauri/src/runtime.rs` + `lib.rs` wiring:
    - `VaultRuntime::start(vault)` — `Index::open` → full `rebuild` → `VaultWatcher::start`. `AppState(Mutex<Option<VaultRuntime>>)` is Tauri managed state.
    - On startup: if a valid vault is configured, build the runtime (log + continue on failure). `initialize_vault` now also starts the runtime so capture works right after first-run.
    - **`save_note` command** — mint a ULID, `created`/`updated` = RFC3339 now (`time` crate), build canonical frontmatter (id/created/updated/type/title), validate via `Note::parse`, `note::write_note`, reconcile into the index; returns the id.

    **Decisions**
    - Timestamps: `time` crate, RFC3339 UTC.
    - `save_note` reconciles **inline** (immediately queryable); the watcher independently handles external edits (idempotent).
    - **Full rebuild on launch** (simple + correct at personal scale); incremental startup is a noted future optimisation.

    **Verification** — verbatim CI commands pass: fmt, clippy `-D warnings` (explicit exit 0, after a PIPESTATUS quirk masked it earlier — I re-checked), `cargo test` (**32 lib tests**, 3 new), `npm run tauri build`. Tests cover save→disk→index, other Types, bad-Type rejection, RFC3339 validity. No UI yet, so nothing interactive to sign off.

    **Scope guard:** no capture UI (DEV-510); no taxonomy selectors / `project` link in the payload (DEV-511); index reads = M4. No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/14 · commit `75c5bc3`
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 14
sprint: sd0ytgj
---
First app-integration of the storage spine (the deferred startup from M2) and the note-creation pipeline the capture window will call.

**Checklist**

- [ ] Tauri **managed state** holding an `Index` (reader connection) + the `VaultWatcher`, initialised when a valid vault is configured
- [ ] On startup with a configured+valid vault: `Index::open` → `rebuild` → `VaultWatcher::start`. Handle the no-vault-yet (first-run) case gracefully
- [ ] `save_note` command — build a `Note` (new ULID id, `created`/`updated` = now, title, body, type, taxonomy values), write to the sharded store (`note::write_note`), and ensure it's indexed (reconcile or rely on the watcher); return the new id
- [ ] Decide the timestamp source for `created`/`updated` (RFC3339)

**Done when:** calling `save_note` persists a note to disk and it appears in the index; the watcher keeps the index live for external edits.

**Scope:** no capture-window UI (that's the next brief); `save_note` is exercised via a temporary test path or the existing window. Consumes DEV-481/482/483/484/508.

---

Linear DEV-509 · M3 — Capture window · created 2026-06-19 · done 2026-06-20