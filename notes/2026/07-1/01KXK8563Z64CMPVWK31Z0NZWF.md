---
id: 01KXK8563Z64CMPVWK31Z0NZWF
created: 2026-07-15T16:01:02.591390351Z
updated: 2026-07-16T07:07:37.430163722Z
type: task
title: Vendor review-due reminders
task_status: backlog
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

- [ ] `NotificationKind.vendor_review_due` + `NotificationTargetType.vendor` (enum migration, add-only).
- [ ] Extend `tasks/reminders.py` with a vendor scan (derived next-review date inside the lead window, targeted at the vendor owner) — dedup via the existing (user, kind, target, due_on) quadruple; rides the existing Beat schedule and per-user digest email.
- [ ] Tests: scan raises/dedups correctly, unowned vendors skipped.

Ref: ADR 0039 §4, ADR 0006.