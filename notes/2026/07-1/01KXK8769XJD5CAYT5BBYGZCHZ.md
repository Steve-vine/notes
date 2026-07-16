---
id: 01KXK8769XJD5CAYT5BBYGZCHZ
created: 2026-07-15T16:02:08.317998455Z
updated: 2026-07-16T22:07:42.967449581Z
type: task
title: Vendor offboarding flow
priority: medium
label:
- brief
task_status: done
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 186
blocked_by:
- 01KXK86XJP75Q7NGAYJ9Q2DAW3
comments:
- id: 01KXP6C8VFECW8RAJ50ADKESPF
  author: Steve Vine
  at: 2026-07-16T19:27:40.911280198Z
  text: |-
    Built on feature/com-186-offboarding (stacked on com-185) — PR #177, merged to staging (e3678f7).

    - POST /api/v1/vendors/{id}/offboard guards the terminal transition on the full checklist (data returned/deleted per exit strategy; access revoked; contracts closed) — partial confirmation 409s naming the missing items; bare PATCH state=offboarded now 409s pointing at the guided flow.
    - In-brief decision: confirmation recorded as a `triggered` VendorReview (audit trail of who confirmed what, when) + the usual revision; compliance_status deliberately untouched — offboarding is a lifecycle exit, not an assurance verdict.
    - OffboardModal on the detail page: three checkboxes + notes, seeded with the vendor's exit-strategy text; confirm gated on all three. No migration.

    Gates: 88 unit + 292 integration, 192 Vitest, mypy strict, ruff, build, Semgrep — all green.
sprint: sjkp918
---
Phase 4 (ADR 0039 §2, §7): a guided checklist before `→ offboarded`, driven by the exit-strategy fields.

- [x] Offboard action on the detail page opens a checklist (data return/deletion confirmed, access revoked, contracts closed — seeded from the exit-strategy/assurance fields) captured on the transition.
- [x] Confirmation recorded (revision + a `triggered` VendorReview or dedicated note field — decide in-brief); state moves to `offboarded` (terminal, admin revert only).
- [x] Tests: transition guarded on confirmation payload.

Ref: ADR 0039 §2, §7.