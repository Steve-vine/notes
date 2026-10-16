---
id: 01M52DAS19ZQPD2KKQS434CH2G
created: 2026-10-16T13:09:57.929933Z
updated: 2026-10-16T13:10:01.552969Z
type: task
title: The assistant can read and raise access Requests — joiners, movers, leavers, group changes and membership changes — and manage its own until they're approved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1016
sprint: scj9zdp
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1013 and COM-1015 (it names roles through COM-1015's lookup).

## What people can ask of it

- **Read (for a named company):**
  - the Requests list, filtered by kind, mode and status.
  - a request in full, as its page shows it:
    - who it's for;
    - the before and after (groups, lists, mailboxes, account details, roles);
    - who approved it;
    - what it's waiting for (Entra, its scheduled time, or on-premises AD);
    - any manual steps.
  - It never reads a joiner's one-time passwords. They stay on screen (ADR, COM-1012).
- **Write (whatever the person's role allows on screen):**
  - **Raise a request**, standard or expedited:
    - a joiner, with the fields the joiner form asks for. Their Primary role fills in its defaults, as on the form.
    - a mover: change roles, account details, manual groups or shared mailboxes. The assistant shows what would change first, as the move form does.
    - a leaver, with its leave date, and whether the account is deleted after so many days;
    - create or delete a group;
    - a membership change.
  - **Before approval:** submit a draft, edit who it's for (at the gate), reschedule, or cancel.
  - An **expedited** request changes the directory as soon as it's raised, with a validator owed. So the assistant treats raising one as destructive, and says so.
- **Example:** "Raise a leaver for Sam Patel, last day Friday, delete the account after 30 days."

## Notes (technical)

- Wraps `access_requests.py`:
  - reads: list, get, joiner-form, joiner-form/people, joiner-form/countries, role-fields, mover-preview and mover-details;
  - writes: POST, submit, subjects PUT, reschedule and cancel.
- `GET /{id}/passwords` is **not** wrapped, and the get tool drops any password field.
- **Raise is one tool per kind** (`access_raise_joiner`, `access_raise_mover`, `access_raise_leaver`, `access_raise_group_change`, `access_raise_membership_change`). The request body is a union, and one tool per kind gives the assistant a schema it can fill in. Each takes `expedited`. Mark the tool `destructive` (it can be expedited), and say in the description that a standard request waits for a second person.
- **Shared lookup:** `find_access_request` (reference or words) in `tools/common.py`, reused by the next two tasks.
- New module `tools/access_requests.py`.
- Tests:
  - passwords never appear in a tool result;
  - expedited needs raise-expedited;
  - a leaver that deletes the account needs delete-account;
  - a raised request is recorded via assistant.

**Done when:** on staging, the assistant raises a mover that adds a role, and it appears on the Requests tab waiting for approval, with the right before and after.