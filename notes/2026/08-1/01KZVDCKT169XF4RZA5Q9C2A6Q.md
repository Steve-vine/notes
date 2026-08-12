---
id: 01KZVDCKT169XF4RZA5Q9C2A6Q
created: 2026-08-12T16:37:47.969332Z
updated: 2026-08-12T16:39:47.153002Z
type: task
title: Dynamic CVE sync scheduling (interval/enabled apply without restart)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 184
sprint: skesb93
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
## Context

The CVE sync runs on Celery Beat: `core/celery_app.py` builds `beat_schedule["sync-cve-data"]` with `crontab(minute=0, hour=f"*/{settings.cve_data_sync_interval_hours}")`. The interval is **frozen at process start** — changing it (even via the new platform settings store) has no effect until Beat is restarted.

For the CVE-database settings UI to "work properly", a schedule/enabled change must take effect **without a pod restart**.

## Scope

Move the CVE sync schedule to a **dynamic scheduler** so changes apply at runtime. Evaluate in plan mode:

* **redbeat** (Redis/Valkey-backed schedule — we already run Valkey) vs a DB-backed custom scheduler vs a self-rescheduling task.
* Note constraint from CLAUDE.md: **Beat is single-replica** (`strategy.type: Recreate`, `replicas: 1` hardcoded). Keep that invariant; production Beat-HA is a separate future decision (M21).
* The `cve_data_sync_enabled` flag must also be honoured live (pausing/resuming without restart).

## Acceptance criteria

* Changing the sync interval via the platform settings store changes the next fire time **without restarting Beat or the API**.
* Toggling `enabled` off stops future runs live; toggling on resumes.
* Single Beat replica invariant preserved; no double-firing.
* `uv run pytest`, `uv run mypy src/`, `ruff` green.

## Reuse

* Existing Beat task `redvektor_api.tasks.cve_sync.sync_cve_data` (queue `maintenance`)
* Valkey (already deployed) if redbeat is chosen

## Dependencies

Reads schedule values from the platform settings store (DEV-660), but can be developed against env values in parallel.

*Triage-level brief — pick the scheduler approach in plan mode before implementing.*

---

Imported from Linear [DEV-661](https://linear.app/stevevine/issue/DEV-661/dynamic-cve-sync-scheduling-intervalenabled-apply-without-restart)