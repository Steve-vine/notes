---
id: 01M3J5FT2XFJDDFW61PEQYYT2Y
created: 2026-09-27T19:29:21.501885Z
updated: 2026-09-27T19:29:36.978763Z
type: task
title: Headless notuvia-mcp sends its daily check-in
project: 01KY6W9951TW0904DT0GGJVGE7
number: 465
sprint: sv8cva3
blocked_by:
- 01M3J5FE19XWBYCGD54ZVADKAH
- 01M3J5F2SPRZM3ZJ0T033HNNW4
assignee: steve
label:
- feature
priority: medium
task_status: todo
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