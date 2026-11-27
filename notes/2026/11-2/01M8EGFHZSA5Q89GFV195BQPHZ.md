---
id: 01M8EGFHZSA5Q89GFV195BQPHZ
created: 2026-11-27T12:42:58.937094Z
updated: 2026-11-27T12:43:09.80353Z
type: task
title: A leaver loses their Entra directory roles, not just their sign-in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2184
sprint: smq8t5s
blocked_by:
- 01M8EGERP5KEBTQB48Q453GS5K
assignee: steve
label:
- feature
priority: medium
task_status: todo
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