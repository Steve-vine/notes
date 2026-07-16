---
id: 01KXK86XJP75Q7NGAYJ9Q2DAW3
created: 2026-07-15T16:01:59.382123042Z
updated: 2026-07-16T22:07:40.625790015Z
type: task
title: Vendor assurance-profile field groups
task_status: done
assignee: steve
label:
- brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 184
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
sprint: sjkp918
---
Phase 4 (ADR 0039 §7): the brief's long vendor-details list as 15 typed columns on `vendors`, one themed migration.

- [x] Contractual: `has_dpa`, `has_security_clauses`, `has_audit_rights`, `liability_terms`, `breach_notification_hours` (0–8760).
- [x] Resilience & compliance: `has_bcdr_capability` + `bcdr_notes`, `regulatory_scope`, `sla_summary`.
- [x] Exit & commercial: `exit_strategy`, `has_cyber_insurance` + `insurance_notes`, `financial_stability_notes`, `external_posture_notes`, `reputation_notes`.
- [x] Migration 0046 extends both `vendors` and the `vendor_revisions` snapshot (`VENDOR_SNAPSHOT_FIELDS` + the snapshot-contract test enforce the pairing). Fields on `VendorUpdate`/`VendorOut`/`VendorRevisionOut` (not Create — assurance is post-onboarding data); Assurance profile card on the detail page with themed sections + tri-state Yes/No/Unknown selects.
- [x] Tests: snapshot contract (unit), PATCH round-trip + revision snapshot (integration), save body + read-only gating (Vitest ×2).

Branch `feature/com-184-assurance-profile`, PR #175 (Sprint 29 stacks: merge first). Ref: ADR 0039 §7.