---
id: 01M89G2CG2CSAEC5WJC88Q32KP
created: 2026-11-25T13:59:35.170484Z
updated: 2026-11-25T14:00:20.052876Z
type: task
title: An Access Admin's own request goes through when they submit it, approved by them (not expedited, nothing owed afterwards)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2166
sprint: s4qjpqd
blocked_by:
- 01M89G1WPC942TTFE0S0S3WQ5P
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Access Control Review". Follows ADR 0179 (COM-2165).

## What people see
- **A new permission, "Approve their own requests"**, under Access Control in Roles and permissions. The Access Admin role and Admin are given it when this arrives. Nobody else is.
- **Someone who holds it raises a standard request** (joiner, mover, leaver, group create/delete, membership change). Before they submit, the form tells them: "This goes through as soon as you submit — as an Access Admin you approve your own requests."
- **On submit**, the request is approved at once, by them, and runs: straight away, or at its scheduled time if it has one. It doesn't wait on the Requests tab, nobody gets an "awaiting approval" email, and nothing is added to anyone's Actions.
- **It isn't expedited.** It is a standard request with no validation owed afterwards and no justification asked beyond what the kind already needs. Expedited (break-glass) is unchanged for everyone.
- **The request reads "Approved by [name] — own request (Access Admin)"**, with the time. The Requests list shows the same, so a self-approved request is never mistaken for one a second person checked. The activity log and the access reports say "self-approved".
- **A privileged change** (for example Domain Admins) also goes through, because an Access Admin holds the privileged right too. Someone given "Approve their own requests" without the privileged right still waits for an Access Admin on a privileged change.
- **Everyone else** is unchanged: their requests wait for a different person to approve them.
- **Requests raised through Polaris** behave the same. The tool's reply says the request went through, approved by them.
- **Requests already waiting** when this arrives are left as they are.

## Done when
In E2E Test Company:
- As an Access Admin test account: raise a membership change. It runs on submit, reads "own request", and no approval email is sent.
- Raise a scheduled leaver. It reads Scheduled (already approved) and runs at its time.
- As an Access Manager (without the permission): raise one. It waits for approval as now, and they can't approve it themselves.
- Take the permission off the Access Admin role. Their next request waits.
- The access report of approved requests can show self-approved ones.

## For the build
- New `Permission.access_approve_own_request`. A migration grants it to the `access_admin` and `admin` role definitions.
- `create_request`: a standard request by a holder → `approved`, `decided_by = requester`, `decided_at = now`, a new flag `self_approved = True`. `_require_privilege_gate` still runs against them, and `_require_sign_in_domains` still applies. Dispatch `execute_access_request` unless scheduled, exactly as `approve_request` does.
- `_require_second_person` stays for everyone else.
- `AccessRequestOut.self_approved`. The approval-pending mail and the action source must skip these (they never enter `pending_approval`).
- Polaris `access_raise_*` tools: say so in the reply.
- Check the access reports' request columns.
- **On the chain**: migration + API.