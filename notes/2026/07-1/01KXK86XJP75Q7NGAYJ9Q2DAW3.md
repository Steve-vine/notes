---
id: 01KXK86XJP75Q7NGAYJ9Q2DAW3
created: 2026-07-15T16:01:59.382123042Z
updated: 2026-07-15T16:02:44.496734119Z
type: task
title: Vendor assurance-profile field groups
task_status: backlog
assignee: steve
label: brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 184
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
---
Phase 4 (ADR 0039 §7): the brief's long vendor-details list as ~14 typed columns on `vendors`, in themed migrations (split into 2–3 PRs by theme if unwieldy).

- [ ] Contractual: `has_dpa`, `has_security_clauses`, `has_audit_rights`, `liability_terms`, `breach_notification_hours`.
- [ ] Resilience & compliance: `has_bcdr_capability` + `bcdr_notes`, `regulatory_scope`, `sla_summary`.
- [ ] Exit & commercial: `exit_strategy`, `has_cyber_insurance` + `insurance_notes`, `financial_stability_notes`, `external_posture_notes`, `reputation_notes`.
- [ ] Each migration extends the `vendor_revisions` snapshot; `VendorOut/Update` + detail-page cards grouped by theme.
- [ ] Tests: revision snapshot covers new columns.

Ref: ADR 0039 §7.