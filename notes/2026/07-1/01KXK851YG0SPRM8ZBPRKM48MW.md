---
id: 01KXK851YG0SPRM8ZBPRKM48MW
created: 2026-07-15T16:00:58.320430556Z
updated: 2026-07-16T07:53:56.825360467Z
type: task
title: Vendor–risk links (raise review findings into the risk register)
task_status: review
assignee: steve
label:
- brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 175
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
sprint: sxady3y
---
Phase 2 (ADR 0039 §4): vendor risks live in the existing register (ADR 0012), not a vendor-local store.

- [x] `vendor_risk_links` join (vendor_id, risk_id composite PK per the ADR; both FKs CASCADE — the vendor-domain join shape, unlink = hard delete of the link row) + migration 0038.
- [x] API: `GET/POST /vendors/{id}/risks` + `DELETE /vendors/{id}/risks/{risk_id}` (slim register rows with residual score/band derived via risk_scoring; company-scoped, duplicate 409) [vendor read/write]; `GET /risks/{id}/vendors` [company read] for the risk-side chip. Each side gated by its own section.
- [x] UI: Linked-risks card on the vendor detail page (band badge + status pill, unlink, "Link existing risk" picker when the user also has Company read, "Raise risk" shortcut when they have Company write — creates a register risk pre-filled from the vendor and links it in one flow); vendor chips on the risk detail header.
- [x] Tests: 4 backend integration (round trip incl. risk side + derived score, duplicate/unknown, cross-company 404, two-sided role gating) + 4 frontend Vitest.

Branch `feature/com-175-vendor-risk-links`, PR #166. Ref: ADR 0039 §4, ADR 0012.