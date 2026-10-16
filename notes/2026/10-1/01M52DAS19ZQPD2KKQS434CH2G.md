---
id: 01M52DAS19ZQPD2KKQS434CH2G
created: 2026-10-16T13:09:57.929933Z
updated: 2026-10-16T20:53:57.008021Z
type: task
title: The assistant can read and raise access Requests — joiners, movers, leavers, group changes and membership changes — and manage its own until they're approved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1016
sprint: scj9zdp
blocked_by:
- 01M52DA7ACHRXD6G83ANQC2EGB
comments:
- id: 01M52YASBSC4DE6DT8NJZYKDF4
  author: Steve Vine
  at: 2026-10-16T18:07:04.056735Z
  text: |-
    Done — merged to main (PR #1006); goes to staging with the rest of the sprint.

    The assistant can now list and read requests (who for, before and after, who approved, what it's waiting for, manual steps — never a joiner's one-time passwords), read the joiner form, preview a move, and raise joiners, movers, leavers, group create/delete and membership changes, standard or expedited. Before approval it can submit a draft, correct a request at the gate, reschedule or cancel.

    My calls:
    - Every raise is flagged destructive (any of them can be expedited, which changes the directory at once). The description says a standard request waits for a second person.
    - Cancelling a request is also flagged destructive — it's final, like rejecting. One word to flip if you'd rather not.
    - The mover preview is its own read-only step; raising a move that changes nothing is refused. A move says which roles to add or remove, not the whole set; when the primary role changes, its default account details fill in as on the form.
    - One joiner per request through the assistant (the screen allows a batch). Fields are named by their label; the primary role's defaults fill in anything left blank; a missing required field is refused with the list of fields. A sign-in name without a domain gets the company's default domain.
    - Times without a time zone are taken as UTC.
    - Reschedule and cancel are offered to anyone who can raise requests, because the person who raised one may do both.
    - Corrections at the gate cover who it's for, a joiner's name/sign-in name/roles/fields, and a new group's name and description. A mover's roles and a membership change's groups are corrected on screen.

    Also fixed in this PR: the assistant couldn't find a mover or leaver by the person's name ("the leaver for Sam Patel") — only by its ACR reference. It now can.

    Worth knowing: a group mapped to a business role can't be deleted until it's unmapped; the refusal says so clearly.
assignee: steve
label:
- feature
priority: high
task_status: done
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