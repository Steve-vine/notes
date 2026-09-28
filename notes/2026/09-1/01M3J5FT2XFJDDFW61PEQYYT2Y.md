---
id: 01M3J5FT2XFJDDFW61PEQYYT2Y
created: 2026-09-27T19:29:21.501885Z
updated: 2026-09-28T09:29:57.825722Z
type: task
title: Headless notuvia-mcp sends its daily check-in
project: 01KY6W9951TW0904DT0GGJVGE7
number: 465
sprint: sv8cva3
blocked_by:
- 01M3J5FE19XWBYCGD54ZVADKAH
- 01M3J5F2SPRZM3ZJ0T033HNNW4
comments:
- id: 01M3KNJTBKS92WXNXQW358TGHV
  author: Steve Vine
  at: 2026-09-28T09:29:51.729615Z
  text: |-
    Built. PR #469 (brief-465-checkin-headless), in Review.

    What landed:
    - notuvia-mcp calls `checkin::start(app_config_dir, Kind::Headless, 5s)` once the vault has opened, in every serving mode. self-update and normalise exit earlier, so they never check in.
    - It runs on its own thread with stderr-only logging, so there's nothing on stdout (the MCP wire).
    - The hourly re-check covers long-running --sync-only daemons.
    - A new core concurrency test: 8 threads, each opening the lock file separately the way processes do, with a slow send. Exactly one sends, and the day is recorded as done.
    - docs/mcp-server.md has a new "Daily check-in" section.

    Live verification: the release binary ran with HOME pointed at a scratch directory, so it used a scratch config dir and a scratch vault.
    - A single run checked in about 22s after start. The 5s delay only starts once the vault has opened, and this scratch vault opens slowly.
    - Three sidecars started together on one config dir: they shared one id, wrote one row, and sent 0 bytes to stdout.
    - The test rows have been deleted.

    Two things from testing, neither in the check-in code:
    - My first harness run exited before the check-in fired, because stdin closed at 12s. That was a problem with the harness, not the code.
    - Three fresh sidecars opening a never-indexed vault at the same moment collided while building the index: one failed with "drop schema: database is locked". This behaviour predates the check-in, and on a normal vault the index already exists. Noting it here rather than filing it, since only an empty scratch vault hits it.

    Checks: cargo test for core and mcp passed 419 + 27 + 2. fmt and clippy are clean.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech:
- rust
- docs
---
Wire the core `checkin` module into `notuvia-mcp` as `kind: headless` (ADR 0064).

## Agreed work

- [ ] On start, in every mode (per-session MCP, `--git-sync`, `--sync-only`), call `checkin::send(Headless)` if `due`, on a background thread, using the existing `app_config_dir()`. It must never delay the MCP handshake or write to stdout, because stdout is the MCP wire.
- [ ] An hourly tick for long-lived processes (`--sync-only` daemons run for weeks).
- [ ] Per-session sidecars start often and several at once. `checkin.json`'s daily date keeps the count down, and the Worker's per-day upsert makes any races harmless. Add a test that two runtimes on one config dir record a single day.
- [ ] `self-update` and other one-shot subcommands don't check in. Only a running server counts as an active install.
- [ ] `docs/mcp-server.md`: a short section telling server operators what is sent, where and how often. Link ADR 0064 and the privacy policy.