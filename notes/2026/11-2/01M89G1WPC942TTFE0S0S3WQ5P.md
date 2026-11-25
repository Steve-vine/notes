---
id: 01M89G1WPC942TTFE0S0S3WQ5P
created: 2026-11-25T13:59:18.988521Z
updated: 2026-11-25T15:02:15.032814Z
type: task
title: 'ADR 0179: who approves an access change — Access Admins approve their own, and recertification removals go through Requests'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2165
sprint: s4qjpqd
comments:
- id: 01M89KN47RF7ANNP0ZBYSGKZ2A
  author: Steve Vine
  at: 2026-11-25T15:02:15.032607Z
  text: |-
    Merged: PR #2170, decisions/0179-who-approves-an-access-change.md, plus the CLAUDE.md ADR line.

    Marked Accepted (25 Nov) because Steve said "go ahead and complete those 4 tasks". Steve: please read it, and say if anything should change.

    The ADR records:
    - §1 Approve their own requests: a permission held by Access Admin and Admin. Self-approved requests are marked and not expedited, and the privileged gate still applies.
    - §2 One "Recertification removals" request per completed review, whatever the number of owners. It has no requester and can't be cancelled.
    - §3 The approver must not be one of the owners who signed off, unless they are an Access Admin.
    - §4 Approval releases each row down today's path. Rejection needs a reason and covers the whole request, never single rows.
    - §5 The review points at its request, and reviews already waiting are carried over.
    - §6 Segregation of duties stated plainly.

    Note: the access reports have no requests subject, so "self-approved in the access reports" isn't possible yet. It shows on the request, the Requests list, the activity log and Polaris.
assignee: steve
label:
- brief
priority: medium
task_status: review
---
Sprint "Access Control Review". Docs only. Merged before the build tasks start.

## Why
Steve, 25 Nov 2026: a Domain Admins review on production that he signed off alone shows "4 removal(s) awaiting approval". Nothing appears on the Requests tab, and Compass won't let him approve it himself. Two decisions follow:
1. **Every completed recertification with removals goes onto the Requests tab**, to be approved there by someone with the right access, however many people reviewed it. Today a review signed off by two or more owners removes access straight away, and one signed off by one owner waits on the review page for a second person.
2. **Walk back "every request needs a second person" for Access Admins.** An Access Admin's own request goes through when they submit it, approved by them. This is not expedited: nothing is owed afterwards (no validation), and expedited stays as it is for everyone.

## What the ADR records
- It supersedes the parts of ADR 0045 (§5/§6 approver ≠ requester, §8 the removal's maker-checker), ADR 0047 §5 (the single-attestor approval on the review and the two-attestor direct removal) and ADR 0061 §5 that these change. It does not rewrite them.
- What "Access Admin" means here: a person holding a new permission, **Approve their own requests**, given to the Access Admin role (and Admin) when it arrives. Roles are editable (ADR 0067), so any role can be given it or have it taken away.
- A privileged change still needs an Access Admin. Because an Access Admin holds that right too, their own privileged request also goes through.
- Recertification removals become one request per review: who raises it, who may approve it, what happens on approval and on rejection, and what happens to reviews already waiting (see the two recertification tasks).
- **Segregation of duties, stated plainly.** Self-approval is limited to a named, small role. Every self-approved request is marked as such on the request, in the activity log and in the access reports. An auditor can list them for the period.

## Done when
- `decisions/0179-*.md` is written. Steve has accepted it and it is merged. Check the number is still free when writing it.
- CLAUDE.md's ADR list has a line for it.