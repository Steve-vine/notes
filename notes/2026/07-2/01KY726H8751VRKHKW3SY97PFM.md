---
id: 01KY726H8751VRKHKW3SY97PFM
created: 2026-07-23T08:41:43.943786Z
updated: 2026-07-23T11:03:34.499137Z
type: task
title: 'notuvia-mcp: headless git-sync mode (--git-sync, --sync-interval)'
assignee: steve
imported_from: null
task_status: done
priority: high
project: 01KY6W9951TW0904DT0GGJVGE7
number: 263
sprint: sv8tvg2
---
## Why

Claude Code will run on a headless Linux server (no desktop, no network path to the laptop running the Notuvia app) and needs read+write access to the vault, with ≤1 minute freshness. The vault is already a GitHub repo with git-sync on (ADR 0013).

Everything needed exists except one gap: `notuvia-mcp` is standalone and its watcher already reconciles the index/taxonomies after external file changes (e.g. a `git pull`), but **only the Tauri app starts the git-sync worker** (`src-tauri/src/lib.rs` → `runtime.enable_git_sync(...)`). The MCP binary writes files assuming the app's sync worker will commit/push (`crates/notuvia-mcp/src/main.rs` header comment). On a server with no app, nothing pulls or pushes.

## What

Add an opt-in headless git-sync mode to `notuvia-mcp`:

* New CLI flags: `--git-sync` and `--sync-interval <secs>` (default 60 for the headless case).
* Guard like the app does: `git::is_available() && git::is_repo_root(&vault)` — fail loudly at startup if not satisfied.
* Make the pull interval configurable: turn `AUTO_SYNC` (currently a 180s const in `crates/notuvia-core/src/gitsync.rs`) into a parameter of `GitSync::start`; the app keeps passing 180s.
* When the flag is set, call `runtime.enable_git_sync(no_op_callback)` at MCP startup. `VaultRuntime` already calls `git_touch()` after every write op, so commit/push after MCP writes needs no per-tool changes; the existing MCP watcher covers reconciliation after pulls.
* On shutdown (stdio transport closes), call `sync_now()` best-effort so writes made at the end of a Claude session aren't stranded.
* Record the decision as a new ADR (headless git-sync mode for the MCP sidecar, extending ADRs 0013/0030).

## Acceptance / verification

* Unit: `gitsync` tests cover the configurable interval; `--git-sync` on a non-repo vault fails with a clear error.
* E2E (two clones on one machine): run `notuvia-mcp --vault clone-A --git-sync --sync-interval 5`; a note created via MCP lands in clone-B via `git pull` within seconds; a note pushed from clone-B is findable via `search_notes` against clone-A within one interval.

---

Linear DEV-916 · Headless Mode · created 2026-07-09 · done 2026-07-09