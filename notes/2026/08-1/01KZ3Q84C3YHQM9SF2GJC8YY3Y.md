---
id: 01KZ3Q84C3YHQM9SF2GJC8YY3Y
created: 2026-08-03T11:48:20.483441Z
updated: 2026-08-05T13:25:52.804761Z
type: task
title: Connector-declared sweep cadence replaces hand-added beat entries
project: 01KX671DATY39VW6GWK3M2T3DN
number: 498
sprint: shk7zaj
assignee: steve
label: null
priority: medium
task_status: backlog
---
The four per-connector Celery beat entries in `worker.py` (`sweep-freshservice-tickets`, `sync-repos`, `check-status-pages`, `scrape-documents`) become declarations the connector/capability makes (extend `sync_spec()` or a sweep spec), dispatched by a generic scheduler loop like `dispatch-syncs`. A new connector needing its own cadence no longer edits `worker.py` or the `include=[...]` list. ADR 0072 State-toggle gating must hold on the generic path.