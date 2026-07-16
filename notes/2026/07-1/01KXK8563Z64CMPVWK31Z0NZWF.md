---
id: 01KXK8563Z64CMPVWK31Z0NZWF
created: 2026-07-15T16:01:02.591390351Z
updated: 2026-07-16T08:26:57.319197831Z
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
comments:
- id: 01KXN0JED78PZ4CSR790EVZ8P4
  author: Steve Vine
  at: 2026-07-16T08:26:57.319069302Z
  text: |-
    Build complete on feature/com-176-review-reminders; PR #167 open against main, branch merged to staging.

    **What was done**
    - _scan_vendors in the daily reminders Beat job: latest-review subquery joined to owned, cadenced, non-dormant/offboarded vendors; next-review derived with the same core/due.add_months arithmetic the API uses (the two can't diverge); notification to the vendor owner inside the lead window, deduped on the existing quadruple, included in the digest email.
    - Enum values via migration 0039 (add-only ALTER TYPE literals — the Semgrep-clean pattern; real promote-pattern downgrade that first deletes vendor-kind notifications).
    - NotificationBell deep-links vendor notifications to /vendors.
    - Integration test covering the raise and all five skip conditions + idempotency; full suites green (84 unit, 8 reminders/db integration, 178 Vitest, build).

    **Decisions made on the fly**
    - Dormant and offboarded vendors are excluded from the scan: offboarded is terminal, and ADR 0039 §2 has re-activation from dormant re-trigger review — reminding about a parked vendor would be noise.
    - The notification body/title reuse the content-review wording shape ("Vendor review due: <name>") for digest consistency.
---
Phase 2 (ADR 0039 §4): overdue/upcoming vendor reviews raise reminders through the existing engine.

- [x] `NotificationKind.vendor_review_due` + `NotificationTargetType.vendor` (migration 0039: add-only ALTER TYPE literals; real downgrade deletes vendor notifications and rebuilds both enums via the promote pattern).
- [x] `tasks/reminders.py` gains `_scan_vendors`: latest-review subquery + the same `add_months` derivation the API uses; notification targeted at the vendor owner when next-review falls inside the lead window — dedup via the existing (user, kind, target, due_on) quadruple; rides the existing Beat schedule and per-user digest email. Unowned/cadence-less/unreviewed and dormant/offboarded vendors skipped.
- [x] Bell deep-links vendor notifications to /vendors; schema.d.ts regenerated.
- [x] Tests: integration test covering raise (owner/target/due_on correctness), all five skip conditions, and idempotent rerun.

Branch `feature/com-176-review-reminders`, PR #167. Ref: ADR 0039 §4, ADR 0006.