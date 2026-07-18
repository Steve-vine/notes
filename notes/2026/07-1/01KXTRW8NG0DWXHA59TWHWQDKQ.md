---
id: 01KXTRW8NG0DWXHA59TWHWQDKQ
created: 2026-07-18T14:07:57.104606944Z
updated: 2026-07-18T18:08:24.136908813Z
type: task
title: Severity mapping, thresholds & scoped override layer
label:
- feature
priority: high
assignee: steve
task_status: active
project: 01KX671DATY39VW6GWK3M2T3DN
number: 115
sprint: stgj737
---
**Sprint 11 (spine).** Implement the severity/threshold model (per its ADR).

- Per-connector native→canonical severity mapping.
- Global auto-incident **threshold** + global **confidence bar** in settings; wire into the open-rule (Alerts: severity ≥ threshold; Observations: severity ≥ threshold AND confidence ≥ bar).
- **Scoped, auditable severity-override layer** (per integration / signal-type / entity) applied as `effective = override ?? connector default`, never mutating the default, with provenance recorded (e.g. "downgraded high→medium by <person>").
- One-click **downgrade** action from the Incident/Observation queue; **Ignore** as hard suppression.

Alembic migration + tests. Depends on Signal/Incident models + the severity ADR.