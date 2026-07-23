---
id: 01KY71R2B1XTX67YZ9MQE3MTZ2
created: 2026-07-23T08:33:49.92169Z
updated: 2026-07-23T11:00:29.128901Z
type: task
title: 'notuvia-mcp: stale taxonomy registry — external taxonomies.yaml edits never reload'
assignee: steve
task_status: done
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 238
sprint: sndmea4
---
Found live-testing DEV-886. The app wires the vault watcher's `on_taxonomies_changed` to `reload_taxonomies()` (src-tauri/src/lib.rs:86); `notuvia-mcp` passes a no-op ([main.rs](<http://main.rs>), `VaultRuntime::start(vault_path, |_| {}, || {})`), so the server's in-memory registry never refreshes when `taxonomies.yaml` changes externally — an in-app taxonomy edit, a git-sync pull, or a hand edit while the server is running.

Consequences: `list_taxonomies` serves stale definitions, and worse, value validation on `create_note`/`update_note`/`add_taxonomy_value` wrongly rejects values that exist on disk (or accepts ones that don't) until the server restarts. Notes don't have this problem — the index reconciles through the watcher regardless.

Suggested fix: the callback can't easily hold the runtime (it's constructed before the `Arc<Mutex>` wrap), so set an `AtomicBool` "taxonomies dirty" flag in the callback and have each tool check-and-clear it, calling `reload_taxonomies()` before doing its work. Add a test: edit `taxonomies.yaml` on disk behind the runtime's back, fire the reload path, assert `list_taxonomies` reflects the change.

---

Linear DEV-891 · MCP Server · created 2026-07-07 · done 2026-07-07