---
id: 01KYWBCNZQTDD04QYYWTFENVT0
created: 2026-07-31T15:06:25.655796Z
updated: 2026-07-31T15:08:00.428685Z
type: task
title: Obs Loop drops per-system config (platform fix)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 438
sprint: s5pft6a
assignee: steve
priority: medium
task_status: backlog
---
Verified pre-existing bug found while planning the Freshservice sprint.

`obs_loop.py:99-104` builds `ConnectorContext(config={"system_name", "system_id"})` and **never spreads `system.config`** — unlike `sync.py:207-215` and `tasks/actions/execute.py:100-106`, which both do `{**(system.config or {}), ...}` with an explicit ADR 0044 comment.

Consequence: any `detect_observations` reading `ctx.config` gets nothing. M365's documented `license_threshold_percent` override (`connectors/m365.py:390`) has silently never worked on the scheduled Obs Loop — it always falls back to the default.

Scope: one line plus a regression test asserting a per-system config value reaches `detect_observations`.

Own branch because it changes another connector's live behaviour and should land even if the rest of the sprint is cut. **This is the sprint's one genuinely headless task** (definition-of-done exception, stated explicitly).