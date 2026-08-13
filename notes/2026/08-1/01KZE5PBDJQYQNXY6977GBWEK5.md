---
id: 01KZE5PBDJQYQNXY6977GBWEK5
created: 2026-08-07T13:13:10.834958Z
updated: 2026-08-13T19:00:09.7744Z
type: task
title: 'Sync Freshness: exclude push-only systems (ISE Estate shows "Never synced")'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 611
sprint: sgyvvx3
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
On the System Status screen, "ISE Estate" permanently sits at the top of the Sync Freshness list as "Never synced". It is a synthetic push-only system (`connector_type="webhook"`, `sync_interval_seconds=None`, minted by `applications._estate_system()` to carry estate-derivation observations) — it can never sync by design, so the row is pure noise and dilutes the real "never synced" alarm.

**Fix:** filter `sync_freshness()` (`ISE_api/system_status.py`) to systems with a non-null `sync_interval_seconds`, rather than special-casing the name — all webhook/push-only systems share the same never-sync shape and would otherwise also sit there forever. `stale_systems()` already requires a truthy interval, so this aligns the list with the staleness logic. After the filter, "never synced" only ever means "should be syncing and hasn't".

Note: the System Status screen currently lives on `feature/ise-593-estate-query-v2` (sprint55 worktree), not yet on main.