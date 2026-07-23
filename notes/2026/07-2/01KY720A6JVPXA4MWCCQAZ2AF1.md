---
id: 01KY720A6JVPXA4MWCCQAZ2AF1
created: 2026-07-23T08:38:20.114535Z
updated: 2026-07-23T08:38:36.033976Z
type: task
title: Editor pauses ~1s intermittently — sync Tauri commands block the main thread
assignee: steve
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 254
label: null
---
## Symptom

While editing in MD or Live view the editor freezes for up to ~1 second from time to time. It is not the Live decorations (it happens in MD view, which carries none).

## Root cause

Every Tauri command in `src-tauri/src/lib.rs` is a plain synchronous `fn`. Tauri v2 runs sync commands **inline on the main thread** (verified against tauri 2.11.3 source: `Webview::on_message` → `run_invoke_handler` runs inline, and WKWebView delivers IPC on the main thread on macOS). Any slow command therefore freezes the WebView.

The periodic trigger is the sync indicator + git-sync cycles:

* `git_sync_state` (`lib.rs`, `git_state`) spawns **three git subprocesses sequentially on the main thread** (`git --version`, `rev-parse --show-toplevel`, `remote get-url origin`).
* `SyncIndicator.svelte` calls it (plus `git_sync_status`) every 10 s on a poll **and twice per git-sync cycle** (the worker notifies at cycle start and end).
* A cycle runs 4 s after every editing burst (debounced commit + network push) and every 180 s (full sync). The start-of-cycle refresh means the main-thread git spawns run concurrently with the worker's `git add -A`/`commit`/`push` on the same disk — worst-case timing, matching "hitches shortly after you pause typing".

Contributing factors:

* Autosave (800 ms) runs `update_note` (file write + SQLite/FTS transaction) on the main thread, then `bumpNotes()` fans out browse/board refetches, each another main-thread command.
* The embedded API server runs a second `VaultRuntime` over the same `index.sqlite` (WAL, 5 s busy timeout) — a save can stall behind its watcher's writes.
* `sync_now` blocks the main thread for a full network round-trip while holding the `AppState` mutex.

## Fix

1. Make commands `async` so Tauri runs them off the main thread (`State<'_, AppState>` works in async commands).
2. Stop spawning git per indicator refresh: cache `GitSyncState` / carry status in the `git-sync-changed` event payload rather than re-deriving it with subprocesses.
3. `sync_now` must not hold the runtime mutex during network I/O.

---

Linear DEV-907 · Editor and Sync · created 2026-07-09 · done 2026-07-09