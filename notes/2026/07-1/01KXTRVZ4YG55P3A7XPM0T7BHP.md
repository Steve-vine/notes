---
id: 01KXTRVZ4YG55P3A7XPM0T7BHP
created: 2026-07-18T14:07:47.358477049Z
updated: 2026-07-18T14:07:47.358477049Z
type: task
title: Alert & Observation signal models (reshape Finding)
priority: high
label: feature
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 113
---
**Sprint 11 (spine).** Implement the transient **Signal** records (per the Signals & Incidents ADR), reshaping today's `Finding` (`models.py`, `promotion.py`, `sync.py`).

- **Alert:** dedup key `source/{id}/{group}` (DataDog `monitor/{id}/{group}`); native severity mapped to canonical; statuses Triggered/Recurring/Recovered/Ignored/Resolved(derived); occurrence history; lifetime window (configurable).
- **Observation:** dedup by event + affected entity; canonical severity + confidence; statuses New/Recurring/Recovered/Ignored/Resolved(derived).
- Ignore = durable suppression (never opens/reactivates an Incident); Resolved cascades from the Incident, never set directly.

Alembic migration (append-only). Integration tests on real Postgres (testcontainers). Depends on the Signals & Incidents ADR.