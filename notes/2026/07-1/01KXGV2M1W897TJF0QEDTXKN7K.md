---
id: 01KXGV2M1W897TJF0QEDTXKN7K
created: 2026-07-14T17:33:58.204301078Z
updated: 2026-07-14T17:34:09.111251744Z
type: task
title: Notify reviewers when content enters the review window
task_status: done
label:
- feature
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 110
sprint: sg31rps
comments:
- id: 01KXGV2YPQ9QQEEE5DV5VTEPQT
  author: Steve Vine
  at: 2026-07-14T17:34:09.111164775Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-30 19:33 UTC]
    Delivered by **DEV-719 / PR #106** (merged + deployed, helm rev 52, image `main-20260630-1927`). Replacing the single content owner with a reviewer set meant the review-due reminder (`tasks/reminders.py::_scan_content`) and the Actions queue now **fan out over `content_reviewers`** — one `content_review_due` notification per reviewer, one Actions row per reviewer. That is exactly the "notify the reviewers" ask here, so closing as done. Design in ADR 0033.
---
Follow-up split from <issue id="5d308c18-6974-4a1a-b99a-254c914fcc6d" href="https://linear.app/stevevine/issue/DEV-718/mark-for-review">DEV-718</issue>. PR #105 shipped the **visual** half of "Mark for Review" — the derived red "Review" pill on published content within 14 days of `next_review_at` (it also raised `reminder_lead_days` 7→14, which widens the existing owner reminder + the M16 Actions window). The **notification** half of <issue id="5d308c18-6974-4a1a-b99a-254c914fcc6d" href="https://linear.app/stevevine/issue/DEV-718/mark-for-review">DEV-718</issue> was not implemented.

<issue id="5d308c18-6974-4a1a-b99a-254c914fcc6d" href="https://linear.app/stevevine/issue/DEV-718/mark-for-review">DEV-718</issue> asked: "Add a notification for the **Reviewers** to review that content." Two things to resolve:

1. **Who are "Reviewers"?** There is no `reviewer` role today (roles are admin/analyst/assessor/viewer; content review is a library-write action → analyst/admin). The existing Beat job (`tasks/reminders.py::_scan_content`) only notifies the content **owner** (`content_review_due`). Decide: notify all analysts/admins, the owner only (already happens), or introduce a reviewer concept.
2. **Implement** the notification accordingly (likely an additional `_scan_content` fan-out or a new `NotificationKind`), with the bell already consuming notifications.

No model change is strictly required for the pill (it derives from `next_review_at`); this issue is purely the notify-reviewers behaviour. Refs: <issue id="5d308c18-6974-4a1a-b99a-254c914fcc6d" href="https://linear.app/stevevine/issue/DEV-718/mark-for-review">DEV-718</issue>, ADR 0032, the M5 notifications engine (<issue id="1c292ad6-deb8-4cc7-82b4-489186c4e041" href="https://linear.app/stevevine/issue/DEV-460/notifications-and-reminders-celery-beat">DEV-460</issue>).

---
*Migrated from Linear [DEV-728](https://linear.app/stevevine/issue/DEV-728/notify-reviewers-when-content-enters-the-review-window) · created 2026-06-30 · completed 2026-06-30*  
*Related to (Linear): DEV-719, DEV-718, DEV-460*