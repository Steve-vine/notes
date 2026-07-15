---
id: 01KXK851YG0SPRM8ZBPRKM48MW
created: 2026-07-15T16:00:58.320430556Z
updated: 2026-07-15T16:02:35.388009071Z
type: task
title: Vendor–risk links (raise review findings into the risk register)
task_status: backlog
assignee: steve
label: brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 175
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
---
Phase 2 (ADR 0039 §4): vendor risks live in the existing register (ADR 0012), not a vendor-local store.

- [ ] `vendor_risk_links` join (vendor_id, risk_id composite PK — mirror `risk_gap_link`) + migration.
- [ ] API: link/unlink endpoints + linked risks on `VendorOut` (or a sub-resource).
- [ ] UI: linked-risks card on the vendor detail page with "raise risk" shortcut (pre-filled from vendor context); vendor chip on the risk detail page.
- [ ] Tests.

Ref: ADR 0039 §4, ADR 0012.