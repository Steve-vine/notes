---
id: 01M3J5FE19XWBYCGD54ZVADKAH
created: 2026-09-27T19:29:09.161476Z
updated: 2026-09-27T19:29:32.06328Z
type: task
title: 'notuvia-core check-in module: install id, daily throttle, send'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 463
sprint: sv8cva3
assignee: steve
label:
- feature
priority: high
task_status: todo
tech:
- rust
---
The client half of ADR 0064, written once in `notuvia-core` so the desktop app and `notuvia-mcp` share it. It doesn't wire anything up itself; the two follow-on tasks do that.

## Agreed work

- [ ] A `checkin` module that takes the app config dir and a `kind` (`Desktop` | `Headless`).
- [ ] `<config dir>/checkin.json` holds `install_id` (UUID v4, minted on first use) and the UTC date each kind last sent. Written by atomic rename. It **must not** touch `config.json`, because the app rewrites that file whole (see the ADR).
  - A missing or corrupt file means mint a fresh id and carry on. Never an error.
  - The id comes from nothing machine-, user- or vault-derived. It must be pure randomness.
- [ ] `due(kind)` is true if this kind hasn't sent today (UTC). `send(kind)` posts `{ install_id, version, os, arch, kind }` to `https://checkin.notuvia.net/v1` and records today's date **only on a 2xx**.
  - `version` comes from `CARGO_PKG_VERSION`. Check it matches the Tauri app version, since `bump-version.mjs` bumps both.
  - `os`/`arch` come from `std::env::consts`, mapped to the Worker's allowed sets.
- [ ] Transport: system `curl` like `selfupdate::fetch`, with a short connect/total timeout (e.g. 5s/10s). Spawn it with no console window on Windows, following the `git::command()` idiom.
- [ ] **Fire and forget.** Everything runs off the caller's thread. Every failure (no curl, offline, non-2xx, timeout) is swallowed apart from one debug-level log line. No retry queue.
- [ ] **Release builds only.** `cfg!(debug_assertions)` makes `send` a no-op, so dev runs and tests never reach the network.
- [ ] Tests with the transport injected, no network:
  - the id persists across loads
  - a corrupt file mints a fresh id
  - `due` flips at the UTC day boundary
  - a failed send doesn't record the date
  - desktop and headless throttle independently
  - the payload has exactly the five fields and nothing more

## Notes

The payload list in ADR 0064 is closed. Adding a field is a new ADR, not a code change.