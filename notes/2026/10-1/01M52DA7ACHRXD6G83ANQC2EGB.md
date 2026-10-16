---
id: 01M52DA7ACHRXD6G83ANQC2EGB
created: 2026-10-16T13:09:39.788015Z
updated: 2026-10-16T18:06:56.534707Z
type: task
title: The assistant can read and change the Role matrix — business roles, what each grants, who holds them, and the joiner defaults, with every change going through a request
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1015
sprint: scj9zdp
blocked_by:
- 01M52D9HBAHAHJ7C3D97Y3FSCB
comments:
- id: 01M52YAFRHKTQ169172THKGGSP
  author: Steve Vine
  at: 2026-10-16T18:06:54.198707Z
  text: |-
    Done — merged to main (PR #1005); goes to staging with the rest of the sprint.

    The assistant can now read the role matrix and one role in full (what it grants, holders and since when, joiner defaults, groups gone from the tenant, rules that withhold its groups), the people with no primary role, and the rules that apply to a person. It can add a role, edit what it grants, change who holds it, replace a vanished group, set joiner defaults, and delete a role (flagged destructive).

    My calls:
    - The "who would this affect" preview is part of the edit itself: without confirm it only says whose access would change; with confirm it saves and hands back the request it raised (ACR reference and link), waiting for a second person. A rename, owner, description or status change saves at once, as on screen.
    - The preview gives counts per group ("gives Payroll-Read to 2 people"), as the screen's confirmation does. Holder changes name each person.
    - Where new starters go (the OU) is set in the role's details, as on screen.
    - A new role can be given its groups, mailboxes and list rights in one go (the screen adds them after creating). Nobody holds a new role, so nothing is raised.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1013. **Do this first among the governance tasks.** Requests, Coverage and Access ▸ Admin find roles through the lookup it adds.

## What people can ask of it

- **Read (for a named company):**
  - the role matrix, as the Role matrix tab shows it. Each role has its owner, status, and what it grants:
    - security groups;
    - Microsoft 365 groups;
    - distribution lists, and the right to send to them as the list;
    - shared mailboxes.
  - one role in full, with its holders and the joiner defaults it fills in (for example, which OU new starters go in);
  - the people with no Primary role set;
  - the membership rules that apply to a person or a role.
- **Write (whatever the person's role allows on screen):**
  - add a role;
  - edit a role: its name, owner, and what it grants. As on screen, the assistant first says whose access would change, then saves, and raises the catch-up request that a second person approves. Nothing in the directory changes until then.
  - add or remove holders, which raises a mover request in the same way;
  - set the joiner defaults;
  - replace a group that has disappeared from the tenant;
  - delete a role.
- **Example:** "Add the Payroll-Read group to the Finance Analyst role. Who would that affect?" Then: "go ahead and raise it."

## Notes (technical)

- Wraps `business_roles.py`: list, without-primary, get, group-change-preview, holders, holder-change-preview, joiner-defaults, and POST/PATCH/holders/PUT/DELETE. Also wraps the reads in `membership_rules.py` for person and role.
- **The preview is part of the edit tool's answer, not a separate step people must remember.** Either the update tool returns the preview with `confirm=false`, or it pairs with a `preview_role_change` tool. Pick whichever reads better to the assistant. Either way, the save returns the request it raised (a reference and a link).
- **Shared lookup:** `find_business_role` (name, scoped to the company) in `tools/common.py`.
- Delete is `destructive`. Edits and holders are writes, but they are not destructive: they land as pending requests.
- New module `tools/access_roles.py`.
- Tests: writes are hidden without manage-business-roles; an edit returns the request it raised; that request and the role change are recorded via assistant.

**Done when:** on staging, the assistant adds a group to a role and shows who it would affect, and the request it raises appears on the Requests tab, waiting for approval.