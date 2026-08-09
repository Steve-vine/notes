---
id: 01KZ9N1X2GAGNW6B2S57WS0RX7
created: 2026-08-05T19:05:25.840386Z
updated: 2026-08-09T07:45:25.355899Z
type: task
title: Windows act support — the four catalogue ops over WinRM
project: 01KX671DATY39VW6GWK3M2T3DN
number: 571
sprint: sesjg7z
assignee: steve
label: null
priority: medium
task_status: review
---
Second half of the ISE-568 write surface (the platform decision: connectivity/facts both platforms from day one, act may land Linux-first with Windows a ticket behind). Depends on ISE-568.

- Same four declared operations, same T2 tiers, no new catalogue entries: `restart_service` / `start_service` / `stop_service` via `ansible.windows.win_service`, `reboot_server` via `win_reboot`, using the write connection profile (admin account).
- **Check-mode caveat, stated honestly**: `win_service` check-mode support is weaker than systemd's — where a genuine `--check --diff` isn't available the preview degrades to reachability + service-exists + current state, and the ProposedChange preview says which level it gave (the DataDog write-model principle: describe what the connector *actually does*).
- `win_reboot` came-back semantics mirror the Linux reboot: bounded wait, explicit came-back / did-not-come-back in the ActionResult.
- Execution-path tests against a fake for every op (connectors-brief DoD item 3) — no live Windows dependency in CI.

**Acceptance**: on a staging Windows box — propose/approve a service restart with the (possibly degraded, honestly labelled) preview shown; reboot round-trips with came-back confirmation; the ActionsPanel offers identical ops on Windows and Linux server entities.