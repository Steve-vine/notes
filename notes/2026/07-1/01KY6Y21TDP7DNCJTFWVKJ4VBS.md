---
id: 01KY6Y21TDP7DNCJTFWVKJ4VBS
created: 2026-07-23T07:29:22.765336Z
updated: 2026-07-23T11:03:35.516923Z
type: task
title: Note identity & sharded storage
comments:
- id: 01KY6Y2AJEJ4SJT9VWJ0XAFCWE
  author: Steve Vine
  at: 2026-07-23T07:29:31.726368Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done** — new `src-tauri/src/note.rs` (`pub mod note`):
    - `NoteId` — **ULID** (`generate` / `parse` / `Display`, 26-char canonical form).
    - `shard_components` / `shard_path` — **pure**, recomputable from the ID alone: `notes/<aa>/<bb>/<id>.md`, `aa`/`bb` = first two bytes of **SHA-256** of the ID (lowercase hex).
    - `write_note` — atomic (create shard dir → write `<id>.md.tmp` → rename into place); `read_note` — read by ID.
    - 7 unit tests: uniqueness/round-trip, parse rejects junk, path determinism + structure, write→read (+ overwrite, no temp left behind), and a **frozen format-pin vector** (`01J9Z3K7P2QF8VN4M0WX5YB6CD → notes/2d/ea/…`).

    **Decisions / notes**
    - ULID + SHA-256 per planning (both ADR-0004 stored-format properties; the pin test guards against accidental change).
    - **Scope-guarded:** content is opaque `&str` (frontmatter = DEV-482); no index (DEV-484); no IPC/UI (capture = M3). It's a tested library layer with no caller yet — `pub mod` keeps it clean under `clippy -D warnings`.
    - No new ADR (implements ADR 0004).

    **Verification** — ran the **verbatim CI commands** locally (avoiding the DEV-480 fmt skew): `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test` (7 pass), `npm run tauri build`. All green. Nothing interactive to sign off here.

    **PR:** https://github.com/Steve-vine/notula/pull/7
    **Branch:** `brief-481-note-identity-sharded-storage` · commit `5ca35a4`
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 6
sprint: svnk3dy
---
Implement note IDs and the on-disk shard layout (ADR 0004, `brief/storage-architecture.md`).

**Checklist**

- [X] ULID/UUIDv7 ID generation — ULID
- [X] Hash-of-id → `notes/<aa>/<bb>/` path resolver (pure function, recomputable from id alone) — SHA-256
- [X] Atomic write (temp + rename) and read by ID
- [X] Create shard directories on demand

**Done when:** a note can be written and read back by ID, landing at the correct sharded path.

---

### Agreed approach (planned 2026-06-19)

* **ID scheme: ULID** (`ulid` crate). **Shard hash: SHA-256** (`sha2`), first 2 bytes → `aa`/`bb`.
* `src-tauri/src/note.rs` (`pub mod`): `NoteId`, pure `shard_components`/`shard_path`, atomic `write_note`/`read_note`. Content opaque (`&str`).
* **Tests (7):** uniqueness/round-trip, parse rejects junk, path determinism+structure, write→read+overwrite, **frozen format-pin vector** (`…YB6CD → notes/2d/ea/…`).

**Scope guard:** no frontmatter/model (DEV-482), no index (DEV-484), no IPC/UI (capture = M3). No new ADR (implements ADR 0004).

**PR:** [https://github.com/Steve-vine/notula/pull/7](<https://github.com/Steve-vine/notula/pull/7>)

---

Linear DEV-481 · M2 — Storage & file handling · created 2026-06-19 · done 2026-06-19