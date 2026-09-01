---
id: 01M0MBN5YJTGNTPWY448MG8942
created: 2026-08-22T09:08:32.338279Z
updated: 2026-09-01T13:55:50.332583Z
type: task
title: 'No self-approval: a request''s submitter cannot decide its approvals'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 346
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
comments:
- id: 01M0MF4MYTQCDE4SHC5AEW4TCS
  author: Steve Vine
  at: 2026-08-22T10:09:24.954018Z
  text: |-
    Done — merged as #348 (be2c36f).

    The check sits in `decide_from_body` inside the existing `if not user.is_admin:` branch, immediately before the area-membership query. Both ticket requirements fall out of that placement: one gate covers both doors (the portal router delegates to this function), and `admin` is exempt without a second condition.

    All decision kinds blocked, as the ticket suggested — the test asserts approve, reject *and* info_requested, and that the approval is still `pending` afterwards, since a refused decision is not a decision.

    **One thing beyond the ticket:** `can_decide` on the approvals queue now mirrors the rule. It already mirrors the one-shot rule for the same stated reason (`test_can_decide_is_false_once_decided`: "the queue must not offer a button that cannot work"), and a listed approver looking at their own request was the remaining case where the row is pending, the area is theirs, and the write is refused. `decide_from_body` is still the enforcement — this only stops the UI offering a button that 403s.

    Tests as specified, plus two: the same approver still decides someone else's request in the same area (a rule keyed to the person rather than the request would take them off every request in their area the first time they raised one), and the rule reaching through the portal door for an approver who also holds `vendor_user` — which is the combination most likely to meet it in practice.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Today nothing stops a listed approver deciding an approval on a request they themselves submitted. It has been latent (managers couldn't decide at all); with `vendor_admin` able to both submit and decide, it becomes real.

- [ ] In `decide_from_body` (`api/v1/vendor_onboarding.py` — shared with the portal router, so one gate covers both doors): if `request.requested_by == user.id`, refuse 403 ("You cannot approve your own request").
- [ ] **Global `admin` is exempt** — the audit log is the mitigation, matching the area-membership bypass they already have.
- [ ] Applies to every decision kind (approve / reject / info_requested? — requesting info from yourself is harmless but nonsensical; simplest is to block the lot and keep the rule one sentence).
- [ ] Tests: submitter who is also a listed approver is refused on their own request but can still decide someone else's; admin decides their own and it lands in the activity log as usual.