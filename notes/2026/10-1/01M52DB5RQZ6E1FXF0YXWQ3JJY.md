---
id: 01M52DB5RQZ6E1FXF0YXWQ3JJY
created: 2026-10-16T13:10:10.967372Z
updated: 2026-10-16T13:11:51.983347Z
type: task
title: The assistant can approve and carry out access Requests — approve or reject, retry, amend, cancel a pending deletion, and mark on-premises steps done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1017
sprint: scj9zdp
blocked_by:
- 01M52DAS19ZQPD2KKQS434CH2G
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1016.

These are the steps that change real accounts in Entra, Exchange and Active Directory. Steve decided on 2026-10-16 that they are **the same as on screen**: if your role can do it, your assistant can too. Each is flagged as destructive, so a client that asks before acting asks first.

## What people can ask of it

- **Read:** what's waiting for you, which is already in the Actions list. The assistant reads each request through COM-1016.
- **Write (whatever the person's role allows on screen):**
  - **approve or reject** a request. As on screen:
    - you can't approve a request you raised;
    - a request that grants a privileged role needs the privileged approval;
    - an approved request runs now, or when its scheduled time comes. A leaver may delete the account.
  - **retry** a request that failed;
  - **amend** a completed request, which raises and carries out the correcting change;
  - **cancel a pending account deletion** before it runs;
  - **mark an on-premises step done, or "can't do"**. Compass can't make some changes in a hybrid or AD-only directory, and someone has to do them by hand.
- **Example:** "What access requests are waiting for my approval? Approve the two movers from Finance, and tell me what the leaver would delete."

## Notes (technical)

- Wraps `access_requests.py`: approve, reject, retry, amend, cancel-deletion, and `subjects/{sid}/manual-steps/done|cannot-do`. Also wraps `manual_steps.py` `done|cannot-do`.
- Approve, retry, amend and cancel-deletion are `destructive`. Reject is too, because it can't be undone. The manual-step marks only record what someone did by hand, so they are writes but not destructive.
- The approve tool's description must say what will happen in the directory. Its result reports the request's new status, and the link to follow it.
- The second-person check and the privileged gate stay in the routes. Prove that the assistant is refused exactly where the screen would refuse the person: approving their own request, and a privileged approval without the grant.
- New module `tools/access_approvals.py`, reusing `find_access_request`.
- Tests: the refusals above; the tools are hidden without approve-request or carry-out-on-prem; an approval is recorded via assistant.

**Done when:** on staging, Steve asks the assistant to approve a mover raised by someone else, and the change lands in Entra with the approval shown as via assistant.