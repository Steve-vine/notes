---
id: 01M3J5FE19XWBYCGD54ZVADKAH
created: 2026-09-27T19:29:09.161476Z
updated: 2026-09-28T09:17:24.167754Z
type: task
title: 'notuvia-core check-in module: install id, daily throttle, send'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 463
sprint: sv8cva3
comments:
- id: 01M3J7ND43HX9DKYEDB35DD0E1
  author: Steve Vine
  at: 2026-09-27T20:07:21.985578Z
  text: |-
    Built. PR #467 (brief-463-checkin-core), in Review. It's an independent branch off main.

    What landed: notuvia_core::checkin, with a single public entry point, `start(config_dir, Kind, delay)`. It spawns a detached thread that waits `delay`, checks in if due, then re-checks hourly. It's a no-op in debug builds.
    - checkin.json in the config dir holds install_id plus the last-sent date per kind, written by atomic rename. If the file is missing or corrupt, or the id isn't v4, a fresh id is minted.
    - The UUID v4 comes from crypto::getrandom. No uuid dependency.
    - The payload is exactly the five fields. The version is CARGO_PKG_VERSION, which is the workspace version the app ships as.
    - If the platform isn't in the Worker's allowed sets, nothing is sent.
    - curl runs with a 5s connect and 10s total timeout, and no console window on Windows. The date is recorded only on a 2xx. Failures produce one eprintln line and are retried on the next hourly tick.

    Changes from the task:
    - due() and send() became one internal check_in(), so the due check and the send happen under the same lock.
    - The lock is new: checkin.lock, an fs4 advisory lock like the git-sync lock. When the app and several sidecars start together, they send once between them. A process that finds the lock held skips its turn and doesn't block. This makes NOT-465's concurrency point cheap.

    Verified:
    - cargo fmt --check, and clippy -D warnings on core and mcp
    - cargo test for core and mcp: 418 + 27 + 2 passed, including 8 new check-in tests
    - the curl flags run against the local Worker: 204 exits 0, 400 exits 22

    The worktree's pre-push frontend steps failed only because it has no node_modules. No frontend code changed.
- id: 01M3KMW0A7J5P3STZFWWCNKHYQ
  author: Steve Vine
  at: 2026-09-28T09:17:24.167342Z
  text: 'Merged as 08dd4ff (squash, PR #467), with CI green. The branch is deleted.'
assignee: steve
label:
- feature
priority: high
task_status: done
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