---
id: 01KXK85SRYTH1CMBR0RDZW7GTF
created: 2026-07-15T16:01:22.718039423Z
updated: 2026-07-15T16:02:39.156822348Z
type: task
title: VendorEngagement entity
assignee: steve
task_status: backlog
label: brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 178
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
---
Phase 3 (ADR 0039 §5): the per-engagement record that approval criteria are evaluated against.

- [ ] `models/vendor_engagement.py` (UUID/Timestamp/Actor/CompanyScoped): `vendor_id` FK RESTRICT, `scope`, `data_types` (JSONB list), `data_residency`, `access_requirements`, `sub_processors`, status proposed/active/ended + migration.
- [ ] Sub-resource API under `/vendors/{id}/engagements` [read/write gates].
- [ ] Engagements card on the vendor detail page.
- [ ] Tests.

Ref: ADR 0039 §5.