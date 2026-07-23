---
id: 01KY734Z5Y0A1DAZXY7EYPKTWJ
created: 2026-07-23T08:58:21.246097Z
updated: 2026-07-23T11:00:29.674174Z
type: task
title: Headless notuvia-mcp should keep itself up to date
assignee: steve
task_status: done
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 354
label: null
---
Observed 2026-07-19: the ISE box's headless `notuvia-mcp` was still on 0.8.0 after the 0.9.0 release — `self-update` (DEV-976) is a manual subcommand only, and nothing in the serve loop or the `--sync-only` worker ever checks the update channel. A peer that never updates chronically lags releases, which matters now that the box is an active second vault writer: the 0.9.0 sync hardening (DEV-995/996/997/1004) only protects the vault when **both** peers run it, and index schema bumps (e.g. v6, DEV-1003) leave a stale binary serving a stale index.

**Change:** teach the long-running modes to keep themselves current.

* The `--git-sync` / `--sync-only` loop periodically checks the channel (reusing the `selfupdate` module's manifest fetch; daily is plenty). When a newer version is available: run the checksum-verified self-update, then **exit cleanly** so the supervisor (systemd `Restart=always`) brings up the new binary — a long-running process must not try to re-exec itself mid-flight.
* The plain MCP serve mode is per-session (spawned by the client), so it doesn't need an in-process updater — but it should log a one-line warning to stderr on startup when the channel has a newer version, so lagging shows up in agent session logs.
* An opt-out flag (`--no-self-update`) for setups that pin versions deliberately.
* Update the ADR 0030 / DEV-919 systemd guidance to note the restart-on-exit requirement.

Until this lands, the manual procedure per box: `notuvia-mcp self-update` + restart the unit(s).

---

Linear DEV-1007 · created 2026-07-19 · done 2026-07-19