---
id: 01KY727HDKFY1EAZ4TWPSCHGDT
created: 2026-07-23T08:42:16.883597Z
updated: 2026-07-23T09:08:58.574081Z
type: task
title: Standalone sync daemon for between-session vault freshness
task_status: done
label: null
priority: low
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 266
---
## Why

With DEV-916, the server's vault clone only syncs while an MCP session is running (it pulls at startup, so sessions never start stale). If it ever matters that the server clone stays fresh **between** sessions — e.g. other tooling reads the files directly, or cron jobs grep the vault — a small always-on sync process would close that gap.

## What (idea, not yet committed)

A `notuvia-sync` headless binary (or a `--daemon` mode) that runs `GitSync` from `notuvia-core` against a vault path under systemd, with the same keep-both conflict handling as the app and MCP modes.

Deliberately deferred from the initial headless-mode work: the stale-between-sessions behaviour is acceptable for the Claude Code use case. Pick up only if a concrete need appears.

---

Linear DEV-919 · Headless Mode · created 2026-07-09 · done 2026-07-09