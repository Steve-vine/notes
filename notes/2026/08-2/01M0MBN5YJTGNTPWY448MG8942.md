---
id: 01M0MBN5YJTGNTPWY448MG8942
created: 2026-08-22T09:08:32.338279Z
updated: 2026-08-22T09:37:02.747127Z
type: task
title: 'No self-approval: a request''s submitter cannot decide its approvals'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 346
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Today nothing stops a listed approver deciding an approval on a request they themselves submitted. It has been latent (managers couldn't decide at all); with `vendor_admin` able to both submit and decide, it becomes real.

- [ ] In `decide_from_body` (`api/v1/vendor_onboarding.py` — shared with the portal router, so one gate covers both doors): if `request.requested_by == user.id`, refuse 403 ("You cannot approve your own request").
- [ ] **Global `admin` is exempt** — the audit log is the mitigation, matching the area-membership bypass they already have.
- [ ] Applies to every decision kind (approve / reject / info_requested? — requesting info from yourself is harmless but nonsensical; simplest is to block the lot and keep the rule one sentence).
- [ ] Tests: submitter who is also a listed approver is refused on their own request but can still decide someone else's; admin decides their own and it lands in the activity log as usual.