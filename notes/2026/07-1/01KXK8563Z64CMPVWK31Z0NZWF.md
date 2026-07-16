---
id: 01KXK8563Z64CMPVWK31Z0NZWF
created: 2026-07-15T16:01:02.591390351Z
updated: 2026-07-16T08:26:45.11636275Z
type: task
title: Vendor review-due reminders
task_status: review
label:
- brief
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 176
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
sprint: sxady3y
---
Phase 2 (ADR 0039 §4): overdue/upcoming vendor reviews raise reminders through the existing engine.

- [x] `NotificationKind.vendor_review_due` + `NotificationTargetType.vendor` (migration 0039: add-only ALTER TYPE literals; real downgrade deletes vendor notifications and rebuilds both enums via the promote pattern).
- [x] `tasks/reminders.py` gains `_scan_vendors`: latest-review subquery + the same `add_months` derivation the API uses; notification targeted at the vendor owner when next-review falls inside the lead window — dedup via the existing (user, kind, target, due_on) quadruple; rides the existing Beat schedule and per-user digest email. Unowned/cadence-less/unreviewed and dormant/offboarded vendors skipped.
- [x] Bell deep-links vendor notifications to /vendors; schema.d.ts regenerated.
- [x] Tests: integration test covering raise (owner/target/due_on correctness), all five skip conditions, and idempotent rerun.

Branch `feature/com-176-review-reminders`, PR #167. Ref: ADR 0039 §4, ADR 0006.