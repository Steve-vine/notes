---
id: 01KY701E34J3JGE68ENT9E1DXS
created: 2026-07-23T08:03:59.716257Z
updated: 2026-07-23T11:03:33.681904Z
type: task
title: Rename Rust crate & internal symbols
assignee: steve
number: 131
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: s865rce
---
Rename the Rust crate and internal code identifiers Notula → Notuvia. Pure code — compiles, no user data touched. The crate-name change ripples, so do it as one coordinated change.

## Changes

* `src-tauri/Cargo.toml` — package `name = "notula"` → `"notuvia"`; lib `name = "notula_lib"` → `"notuvia_lib"`.
* `src-tauri/src/main.rs` — `notula_lib::run()` → `notuvia_lib::run()`.
* `Cargo.lock` — regenerates on build; commit the update.
* `src-tauri/src/git.rs` — internal fn `ensure_notula_ignored` → `ensure_notuvia_ignored` (and its call site in `lib.rs` + test names). Cosmetic but in scope for "all code".
* `src-tauri/src/runtime.rs` — local bindings/params named `notula` (the ones unrelated to the `.notula` dir path string — those live in the index-dir issue).
* **Runtime git identity** (visible in the user's vault history): `src-tauri/src/git.rs` `user.name=Notula` / `user.email=notula@localhost` → Notuvia; `src-tauri/src/gitsync.rs` commit prefix `"notula: vault update {}"` → `"notuvia: vault update {}"`.

## Done when

* `cargo build` / `cargo test` pass with the new crate names.
* No `notula` identifier remains in Rust source except the on-disk path strings owned by the index-dir/migration issues.

---

Linear DEV-736 · Rebrand · created 2026-06-30 · done 2026-06-30