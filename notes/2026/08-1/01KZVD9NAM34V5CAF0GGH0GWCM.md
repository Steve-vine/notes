---
id: 01KZVD9NAM34V5CAF0GGH0GWCM
created: 2026-08-12T16:36:11.220082Z
updated: 2026-08-12T16:36:11.220082Z
type: task
title: CVE mirror admin API (settings GET/PUT, on-demand sync + full-backfill triggers, status)
assignee: steve
imported_from: linear
priority: high
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 180
---
## Context

Backend API surface for the CVE database settings tab. Today there is only `GET /api/v1/admin/cve-mirror-health` (super-admin) and the Beat task / CLI — **no way to change settings or trigger a sync from the API**.

## Scope (all super-admin gated, `api/v1/routes/admin.py`)

* **Settings GET/PUT** — read/write the CVE knobs via the platform settings store (DEV-660): `nvd_api_key` (write-only / masked on read), `cve_data_sync_interval_hours`, `cve_sync_max_pages_per_run`, `cve_data_sync_enabled`, `cve_mirror_stale_after_hours`. Validate against existing ranges.
* **Trigger sync** — `POST .../cve-mirror-sync/trigger` enqueues `sync_cve_data` (incremental). Return a handle/202; guard against concurrent runs.
* **Trigger full backfill** — `POST .../cve-mirror-sync/backfill` safely resets backfill state (per DEV-662) and runs it; idempotent / not double-startable.
* **Status** — extend the health response (or add an endpoint) with per-source status (DEV-663) and backfill progress (DEV-662): count, cpe/kev/epss counts, per-source last-sync/error, backfill %/index/total, key-in-use flag, staleness.
* New schemas in `api/v1/schemas/cve.py`. Run `gen:api` so the frontend gets TS types.

## Acceptance criteria

* A super-admin can read settings (key masked), update them (persisted to the settings store, applied without restart), trigger a sync and a full backfill, and read live status incl. backfill progress.
* Non-super-admin → 403.
* Concurrent trigger requests don't start overlapping syncs.
* `uv run pytest`, `uv run mypy src/`, `ruff` green; OpenAPI regenerated.

## Reuse

* `services/cve_health.py`, `tasks/cve_sync.py`, `require_super_admin`

## Dependencies

Blocked by DEV-660 (settings store). Status shape coordinates with DEV-662 / DEV-663. Blocks the CVE database tab.

*Triage-level brief.*

---

Imported from Linear [DEV-665](https://linear.app/stevevine/issue/DEV-665/cve-mirror-admin-api-settings-getput-on-demand-sync-full-backfill)