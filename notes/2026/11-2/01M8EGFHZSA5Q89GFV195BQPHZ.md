---
id: 01M8EGFHZSA5Q89GFV195BQPHZ
created: 2026-11-27T12:42:58.937094Z
updated: 2026-11-27T22:31:18.360132Z
type: task
title: A leaver loses their Entra directory roles, not just their sign-in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2184
sprint: smq8t5s
blocked_by:
- 01M8EGERP5KEBTQB48Q453GS5K
comments:
- id: 01M8F0SARTT28NWVR345TVHZJ5
  author: Steve Vine
  at: 2026-11-27T17:27:56.442101Z
  text: |-
    Done — merged to main in PR #2196. Not on staging yet; it goes with the sprint.

    What changes:
    - A leaver request lists the directory roles the person is losing, e.g. "Global Administrator (eligible, direct)" and "Exchange Administrator (active, through Exchange Admins)". A role held through a group goes when they leave the group, as before. Roles assigned straight to them are now taken away too.
    - Leavers stay urgent. The disable, sign-out and memberships happen first, at once; role removal comes after and never holds them up. A scheduled leaver loses the roles at the leave time with everything else.
    - Each direct role is handled one of two ways:
      - Compass removes it itself when its app holds the role-write permission and an Access Privilege Approver (not the requester) approved the leaver.
      - Otherwise, or if Microsoft refuses, it becomes an urgent to-do: "Remove Sam Jones's Global Administrator (eligible), in Entra". It's emailed straight away like any leaver step and closed by the next Entra read.
    - Approval order, my decision: an Access Admin's approval runs the leaver at once, leaving the roles as urgent to-dos for a person. The leaver is never held waiting for an Access Privilege Approver; an Approver's approval only lets Compass do the role part itself.

    Checks:
    - Three new tests:
      - without the permission: roles listed, account disabled at once, urgent to-do with its reason;
      - with the permission and an Approver: Compass removes the role;
      - with the permission and only an Access Admin: account disabled at once, role left to a person.
    - Leaver suites passed (19).
    - Unit suite passed.
    - All ten CI jobs passed.

    For pre-UAT on staging:
    - The to-do path is checkable with an E2E leaver holding a test role.
    - Compass removing the role itself needs the role-write permission in the staging tenant. If it isn't granted, that part is Couldn't check.
- id: 01M8F9ZYRDJ4ZH99DV50AXWMSW
  author: Steve Vine
  at: 2026-11-27T20:08:50.700519Z
  text: |-
    Pre-UAT on staging 30786db4f: Couldn't check (Compass Test holds no directory roles).

    Steps and what I saw:
    - As E2E Access Manager, I opened Compass Test's popup (Access Control ▸ Users). It shows Active assignments 0 ("No active directory-role assignments") and Eligible assignments 0 ("No eligible (PIM) assignments").
    - New request ▸ Leaver ▸ Compass Test. The form lists the account disable, sessions revoked, no managed-group changes and 7 other groups. There is no directory-roles line, which is correct because they hold none.
    - I raised it as ACR-208. The request page lists only the leaver (no "Losing directory roles"). As E2E Admin B, I rejected it: "Pre-UAT check, not to be carried out".

    Couldn't check:
    - the form and request listing "Global Administrator (eligible, direct)" style lines;
    - the account disabled at once with the role left as an urgent "Remove …'s … in Entra" to-do that closes on the next Entra read.
    That needs a test person holding a directory role assigned straight to them, and an approved leaver.
    For Steve: give a test account a low-privilege eligible role (e.g. Message Center Reader), raise a leaver for it, and check the roles appear under what they lose.

    Screenshots: ~/compass-uat/sprint-128/COM-2184/ (01 the leaver form, 02 ACR-208, 03 Compass Test with no roles, 04 ACR-208 rejected).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
**On the chain** (API; possibly a migration for new change kinds). Stacks on COM-2182 (Compass changes roles when permitted) and COM-2181 (Access Privilege Approver).

Steve's decision (27 Nov 2026): a leaver's directory roles are **removed**. Today a leaver disables the account, revokes its sessions and strips its group memberships, but any directory role assigned straight to the person, active or eligible, stays on the disabled account.

## What people see
- **The leaver form and request** list the person's directory roles under what they lose: "Global Administrator (eligible, direct)", "Exchange Administrator (active, through Exchange Admins)".
  - Roles held **through a group** go when the group membership does, as already happens.
  - Roles assigned **directly** are now removed too.
- **Approval:** a leaver for someone holding a directory role already needs an Access Admin. If Compass will remove a role itself (COM-2182's permission is granted), it needs an **Access Privilege Approver** (COM-2181).
- **Leavers stay urgent:** the rest of the leaver (disable, revoke sessions, memberships) still runs at once and isn't held back by role removal.
- **Without the permission,** each role becomes an urgent to-do ("Remove Sam Jones's Global Administrator, in Entra"), emailed straight away like any leaver step, and closed by the next Entra read.
- **Scheduled leavers** remove the roles at the leave time, with everything else.

## Notes (technical)
- Leaver building: find the leaver plan (`core/leaver*.py` / `tasks/access_execute.py` leaver path). Add role removals from `directory_role_assignments` where the principal is the user. Group-held roles are already handled through membership removal.
- Use COM-2182's removal calls and routing. A role removal failing must not fail the account disable: record it on the subject and raise the to-do.
- Watch the approval order: an urgent leaver whose role removal needs an Access Privilege Approver mustn't wait for one before disabling the account. Either split approval (roles approved separately), or let the disable proceed and send the role removal through approval. Decide in the PR and say which in the task comment. **Default: disable at once; role removal waits for its approver, shown as "waiting for an Access Privilege Approver".**

**Done when:** on staging:
- A leaver for a test person with an eligible role assigned directly lists the role.
- After approval, the account is disabled at once and the role is removed by Compass (permission granted) or raised as an urgent to-do (not granted), closing on the next Entra read.