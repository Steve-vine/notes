---
id: 01KY71JN0FE7HDCGB539BANZV0
created: 2026-07-23T08:30:52.431715Z
updated: 2026-07-23T08:30:52.431715Z
type: task
title: Extract a Tauri-free core crate so a headless binary can link the vault engine
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 226
---
Restructure `src-tauri` into a Cargo workspace so the vault engine — `note.rs`, `vault.rs`, `index.rs`, `taxonomy.rs`, `crypto.rs`, `config.rs`, and the non-Tauri parts of `runtime.rs` — lives in a core crate with no `tauri` dependency. The Tauri app crate depends on it; the upcoming `notuvia-mcp` binary (DEV-868 plan, Option A) will too.

Acceptance:

* Core crate builds and its tests pass with no Tauri/WebView toolchain in the loop.
* App behaviour unchanged; `npm run tauri:dev` and the pre-push gate still work.
* No logic changes — this is a move, not a rewrite. Anything that genuinely needs `AppHandle`/`State` stays in the app crate.

Context: decided in DEV-868 (see ADR 0030). Side benefit: core logic becomes testable on Windows CI without packaging.

---

Linear DEV-879 · MCP Server · created 2026-07-07 · done 2026-07-07