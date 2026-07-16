---
id: 01KXK851YG0SPRM8ZBPRKM48MW
created: 2026-07-15T16:00:58.320430556Z
updated: 2026-07-16T08:20:18.411175687Z
type: task
title: Vendor–risk links (raise review findings into the risk register)
task_status: done
assignee: steve
label:
- brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 175
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
comments:
- id: 01KXMYPHKHAYMYMSBEA13XZ65B
  author: Steve Vine
  at: 2026-07-16T07:54:14.513401758Z
  text: |-
    Build complete on feature/com-175-vendor-risk-links; PR #166 open against main, branch merged to staging.

    **What was done**
    - VendorRiskLink composite-PK join (migration 0038); vendor-side link/list/unlink endpoints returning slim register rows with the residual score/band derived exactly like the register (shared risk_scoring); risk-side GET /risks/{id}/vendors for the detail-page chip.
    - Vendor detail Linked-risks card: unlink for vendor writers, "Link existing risk" picker shown only when the user also holds Company read (the risk list is Company-section data), and a "Raise risk" modal (Company write) that creates a pre-filled register risk and links it in one flow.
    - Risk detail header now shows cyan vendor chips linking back to the vendor.

    **Problems encountered**
    - COM-174's main-push release run failed on the known COM-188 flaky (LoginPage teardown race) — rerun of the frontend job fixed it, full run green; noted a second occurrence on COM-188.
    - My new useRiskVendors fetch collided with RiskDetailPage.test's catch-all /api/v1/risks/r1 stub (returned an object where an array was expected, blanking the page render) — fixed by adding a /vendors handler to that stub.

    **Decisions made on the fly**
    - Composite PK + CASCADE + hard-delete unlink follows the ADR text and the vendor-domain join precedent (vendor_flag_assignments), not the older risk_*_links soft-delete shape — the task text said both; the ADR wins.
    - Cross-section permissions are compositional: linking needs vendor write + Company read, raising needs vendor write + Company write; pure vendor roles see the card read-only. Admin has everything.
- id: 01KXN068VB2T3AASZJ36CVHAQE
  author: Steve Vine
  at: 2026-07-16T08:20:18.410991769Z
  text: 'Released: PR #166 squash-merged to main as 8310239 (COM-175: Vendor-risk links). Main-push CI (test suite + production deploy) triggered; feature branch deleted. Marking Done.'
sprint: sxady3y
---
Phase 2 (ADR 0039 §4): vendor risks live in the existing register (ADR 0012), not a vendor-local store.

- [x] `vendor_risk_links` join (vendor_id, risk_id composite PK per the ADR; both FKs CASCADE — the vendor-domain join shape, unlink = hard delete of the link row) + migration 0038.
- [x] API: `GET/POST /vendors/{id}/risks` + `DELETE /vendors/{id}/risks/{risk_id}` (slim register rows with residual score/band derived via risk_scoring; company-scoped, duplicate 409) [vendor read/write]; `GET /risks/{id}/vendors` [company read] for the risk-side chip. Each side gated by its own section.
- [x] UI: Linked-risks card on the vendor detail page (band badge + status pill, unlink, "Link existing risk" picker when the user also has Company read, "Raise risk" shortcut when they have Company write — creates a register risk pre-filled from the vendor and links it in one flow); vendor chips on the risk detail header.
- [x] Tests: 4 backend integration (round trip incl. risk side + derived score, duplicate/unknown, cross-company 404, two-sided role gating) + 4 frontend Vitest.

Branch `feature/com-175-vendor-risk-links`, PR #166. Ref: ADR 0039 §4, ADR 0012.