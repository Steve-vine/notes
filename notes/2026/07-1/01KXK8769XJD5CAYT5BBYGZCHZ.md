---
id: 01KXK8769XJD5CAYT5BBYGZCHZ
created: 2026-07-15T16:02:08.317998455Z
updated: 2026-07-16T19:14:31.487734215Z
type: task
title: Vendor offboarding flow
priority: medium
label:
- brief
task_status: active
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 186
blocked_by:
- 01KXK86XJP75Q7NGAYJ9Q2DAW3
sprint: sjkp918
---
Phase 4 (ADR 0039 §2, §7): a guided checklist before `→ offboarded`, driven by the exit-strategy fields.

- [ ] Offboard action on the detail page opens a checklist (data return/deletion confirmed, access revoked, contracts closed — seeded from the exit-strategy/assurance fields) captured on the transition.
- [ ] Confirmation recorded (revision + a `triggered` VendorReview or dedicated note field — decide in-brief); state moves to `offboarded` (terminal, admin revert only).
- [ ] Tests: transition guarded on confirmation payload.

Ref: ADR 0039 §2, §7.