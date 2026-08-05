---
id: 01KYWBCNZQTDD04QYYWTFENVT0
created: 2026-07-31T15:06:25.655796Z
updated: 2026-08-05T12:34:27.948733Z
type: task
title: Obs Loop drops per-system config (platform fix)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 438
order: 1.0625
sprint: s5pft6a
comments:
- id: 01KYX44T0EHNYF1DZQ3K615AJ1
  author: Steve Vine
  at: 2026-07-31T22:19:02.030804Z
  text: |-
    Done — PR #385, CI green (backend, backend-lint, api-types, secret-scan all pass).

    **The fix:** `run_obs_loop` now spreads `system.config` into the `ConnectorContext`, with the config spread *first* so tenant config can never shadow the reserved `system_name`/`system_id` keys — the same ordering `sync.py` and the action executor already use.

    **Confirmed the bug was real, not theoretical.** The new regression test was run against the *unfixed* code first and failed, then passed with the fix. So M365's `license_threshold_percent` override genuinely never took effect on the scheduled Obs Loop: `_license_threshold` always fell through to its 90% default. Any install that had tuned that value has been running on the default without any signal that it was being ignored.

    The test asserts both halves: the override arriving at the detector, and the shadowing rule (a system config containing `system_name: "spoofed"` must lose to the real value).

    Verification: 11/11 obs-loop tests, 84 M365 + obs tests, `ruff check`, `ruff format --check` and `mypy` (461 files) all clean. No migration, no API change — OpenAPI snapshot unchanged.
assignee: steve
priority: medium
task_status: done
---
Verified pre-existing bug found while planning the Freshservice sprint.

`obs_loop.py:99-104` builds `ConnectorContext(config={"system_name", "system_id"})` and **never spreads `system.config`** — unlike `sync.py:207-215` and `tasks/actions/execute.py:100-106`, which both do `{**(system.config or {}), ...}` with an explicit ADR 0044 comment.

Consequence: any `detect_observations` reading `ctx.config` gets nothing. M365's documented `license_threshold_percent` override (`connectors/m365.py:390`) has silently never worked on the scheduled Obs Loop — it always falls back to the default.

Scope: one line plus a regression test asserting a per-system config value reaches `detect_observations`.

Own branch because it changes another connector's live behaviour and should land even if the rest of the sprint is cut. **This is the sprint's one genuinely headless task** (definition-of-done exception, stated explicitly).