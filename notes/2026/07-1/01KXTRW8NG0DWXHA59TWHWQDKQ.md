---
id: 01KXTRW8NG0DWXHA59TWHWQDKQ
created: 2026-07-18T14:07:57.104606944Z
updated: 2026-07-21T17:37:26.828426Z
type: task
title: Severity mapping, thresholds & scoped override layer
project: 01KX671DATY39VW6GWK3M2T3DN
number: 115
sprint: stgj737
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 11 (spine).** Implement the severity/threshold model (per ADR 0026).

**Delivered (backend spine — on staging, PR #102):**
- Per-connector native→canonical severity mapping already existed (DataDog `_STATE_SEVERITY`); this adds the rule around it.
- Global auto-incident **threshold** + **confidence bar** (`AutoIncidentPolicy`, enforced-singleton, admin-set/viewer-read); wired into the open rule (Alert ≥ threshold; Observation ≥ threshold AND confidence ≥ bar).
- **Scoped, auditable severity-override layer** (`SeverityOverride`; integration/signal-type/kind, most-specific wins) applied as `effective = override ?? connector_default`, never mutating the default; incidents carry the effective severity.
- **Ignore** = durable hard suppression that ingest never overrides.
- Operator/admin API: `/incident-policy`, `/severity-overrides` CRUD, one-click `/findings/{id}/downgrade` + `/ignore`.
- Migration 0022; unit + real-Postgres tests; full suite green (512).

**Deferred:** the one-click **buttons** in the queue → ISE-117 (backend ready). True per-*entity* override scope → after the estate graph (Sprint 12); `kind` is the finest scope today and covers the g5 pod-restart case.