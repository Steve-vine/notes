---
id: 01M68M5F40AHEBHWV612J2EFPP
created: 2026-10-31T09:20:32.384916Z
updated: 2026-10-31T09:20:32.384916Z
type: task
title: A standard access request waiting for approval is on its approvers' Actions — today it reaches nobody, on the list or by email
priority: high
label: bug
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1472
---
Sprint 100, Actions. Found on 2026-10-30 while checking what Actions includes.

## What's wrong

- An **expedited** request waiting for its second person is on Actions ("validate").
- A **standard** request waiting for approval (a joiner, mover, leaver, group change or membership change, e.g. ACR-72) is not on anyone's Actions. Nothing emails the approvers either.
- So it waits until someone happens to open Access ▸ Requests.

## What people see after

- **Access request · Approve** "ACR-72 · Joiner for Compass Test", owned by the type's default owner (COM-1469; it starts as the role that can approve access requests).
- It's due a set number of days after it was raised, and emails straight away, because someone is waiting.
- It goes when the request is approved, rejected or cancelled.
- The person who raised it never sees it as theirs to approve, even when they're in the approving role.

## Notes (technical)

- New source in `core/actions/access.py` on `AccessRequestStatus.pending_approval`, with the requester excluded per reader, as `_scan_access_validations` does for validations.
- `immediate` urgency.
- MCP access tools: none change. The approve tool already refuses your own.

**Chain:** on the chain (new action type). Blocked by COM-1470.

**Done when:** on staging, E2E Access Manager raises a standard joiner in E2E Test Company. E2E Admin A sees "Access request · Approve" on Actions and gets the email (in mailpit), and E2E Access Manager does not see it. Reject it afterwards and never approve it (ADR 0135: the directory is real).