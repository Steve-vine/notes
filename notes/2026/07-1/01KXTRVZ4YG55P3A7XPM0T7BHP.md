---
id: 01KXTRVZ4YG55P3A7XPM0T7BHP
created: 2026-07-18T14:07:47.358477049Z
updated: 2026-07-21T16:23:12.90283Z
type: task
title: Alert & Observation signal models (reshape Finding)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 113
sprint: stgj737
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 11 (spine).** Implement the transient **Signal** records (per the Signals & Incidents ADR), reshaping today's `Finding` (`models.py`, `promotion.py`, `sync.py`).

**Delivered (accepted slice — merged to main):** additive signal fields on `Finding` + the machine-driven lifecycle.
- `signal_type` (alert/observation, default alert), `status`, `confidence` columns (migration 0021).
- Lifecycle at sync: Triggered → Recovered (cleared on its own) → Recurring (came back); Resolved cascades from the Incident (ISE-114), never set directly.

**Deferred (additive follow-ons, no throwaway):**
- Dedup/correlation key `source/{id}/{group}` (DataDog `monitor/{id}/{group}`) → **ISE-120** (stable-key ingest correlation).
- Occurrence history, configurable lifetime window, and the distinct **Observation** model (dedup by event + affected entity) → Sprint 14 (Obs Loop & Observations).
- Ignore = durable suppression → ISE-115 (severity/override + Ignore action).