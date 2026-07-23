---
id: 01KXTRVNC7S6TTMT066N07N21N
created: 2026-07-18T14:07:37.351659382Z
updated: 2026-07-23T18:39:05.122592Z
type: task
title: 'ADR: Canonical severity, confidence & auto-incident thresholds'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 111
sprint: stgj737
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 11 (spine).** Record the severity/threshold model (per the ISE Canon):

- One **canonical severity ladder** `info < low < medium < high < critical` (reuse `ISSUE_SEVERITIES`, `models.py:21`); a source's native scale is a subset (DataDog tops out at `high`).
- **Per-connector mapping** of native levels onto the ladder (DataDog `Alert→high, Warn→medium, No Data→low`).
- A **global auto-incident threshold** (e.g. ≥ High) + a **global confidence bar**: Alerts auto-open if severity ≥ threshold; Observations if severity ≥ threshold AND confidence ≥ bar. Threshold governs automation only — manual open always allowed.
- **Scoped, auditable severity-override layer** over connector defaults: `effective = override ?? default`, never mutating the default, with provenance. One-click downgrade from the queue; Ignore as hard suppression.

Deliverable: `docs/decisions/NNNN-severity-and-thresholds.md`.