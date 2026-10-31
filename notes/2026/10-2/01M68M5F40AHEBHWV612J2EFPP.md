---
id: 01M68M5F40AHEBHWV612J2EFPP
created: 2026-10-31T09:20:32.384916Z
updated: 2026-10-31T11:21:55.537699Z
type: task
title: A standard access request waiting for approval is on its approvers' Actions — today it reaches nobody, on the list or by email
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1472
sprint: scpaa6p
blocked_by:
- 01M68M4TR5X3N0A30R9F8XGY5V
comments:
- id: 01M68V3PRD5KYKJKCF5C300AP1
  author: Steve Vine
  at: 2026-10-31T11:21:54.701458Z
  text: |-
    Done: PR #1490 merged (6883c76c).

    - **A standard access request waiting for approval is now an action.** That covers joiners, movers, leavers, group changes and membership changes. It shows as Access request · Approve, "ACR-72 · Leaver request", and opens the request.
    - **Who owns it:** the Access team (access approvers), or whoever Admin ▸ Actions names. It's due 2 days after it was raised and is emailed on the next run, because someone is waiting.
    - **Never the requester's.** The person who raised it never sees it as theirs to approve, even if they're an approver.
    - **It goes** when the request is approved, rejected or cancelled.

    To test on staging, in E2E Test Company:
    1. E2E Access Manager raises a standard joiner.
    2. E2E Admin A should see "Access request · Approve" on Actions and get the email (in mailpit). E2E Access Manager should not see it.
    3. Reject it afterwards. Never approve it: the directory is real.
assignee: steve
label:
- bug
priority: high
task_status: review
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