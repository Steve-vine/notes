---
id: 01M8EGE7NVV4QKKWT3C06JEJHP
created: 2026-11-27T12:42:15.611185Z
updated: 2026-11-27T13:27:44.428355Z
type: task
title: Access Privilege Approver — only its members can approve a privileged change Compass will make itself; the one role Admin doesn't hold
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2181
sprint: smq8t5s
assignee: steve
label:
- feature
priority: high
task_status: active
---
**On the chain** (migration seeds the role; API changes who may approve). Build this **before** anything that lets Compass change privileged access itself: COM-2179 (AD protected objects) and the Entra role tasks (COM-2182–2184).

Steve's decision (27 Nov 2026): now that Compass can change AD's protected objects and Entra directory roles itself, those changes need an extra level of approval.

## What people see
- **A new built-in role, Access Privilege Approver.** It holds one permission: "Approve privileged changes Compass makes itself".
  - It's the **only** role the built-in Admin doesn't include automatically. An Admin doesn't hold it unless they're also given this role.
  - That permission can't be ticked into any other role, so membership of this role is the one way to hold it.
- **What counts as a privileged change Compass will make itself:** a change that Compass, not a person, will carry out, and that does any of these:
  - grants or removes an **Entra directory role**, eligible or active (COM-2182, COM-2183);
  - changes the membership of a **group that grants an Entra role**;
  - changes a **group or account AD protects** (COM-2179);
  - is a **leaver** whose removals include any of the above (COM-2184).
- **Who can approve it:** only an Access Privilege Approver. The request page says so before anyone acts: "Compass will make this change itself — it needs an Access Privilege Approver." Anyone else sees the approve button disabled, with that reason.
- **Manual changes are unchanged.** If the same change will become a to-do, because Compass hasn't been given the rights, approval works exactly as today (an Access Admin for privileged work). The page says "This will be a to-do for an admin."
- **Recertification removals** follow the same rule: if the review's removals request includes a privileged change Compass will make itself, it needs an Access Privilege Approver.
- **Break-glass (expedited):** a privileged change Compass would make itself can only be raised as expedited by an Access Privilege Approver.
- **Safety net at the moment of change:** if, by the time a request runs, Compass has gained rights it lacked at approval, so a planned to-do would now be automatic, it still becomes a **to-do** unless an Access Privilege Approver approved it. Compass never makes a privileged change on an approval that wasn't theirs.
- **No self-approval:** an Access Privilege Approver can't approve their own privileged change, even if they can approve their own requests otherwise. A second person is always needed, so at least two people should hold the role.
- **Giving someone the role:** anyone who can manage users can give it, but not to themselves, except for the very first holder. Every grant and removal of it is in the activity log.

## Notes (technical)
- **ADR 0183**, "Who approves a change Compass makes to privileged access itself", building on ADR 0061 §5 and ADR 0179.
- **Permission:** a new one, e.g. `access.approve_privileged_execution`. Add a third set beside `BUILT_IN_ONLY_PERMISSIONS`, e.g. `EXCLUDED_FROM_ADMIN`.
  - `ADMINISTRATOR_PERMISSIONS = ALL_PERMISSIONS − BUILT_IN_ONLY − EXCLUDED_FROM_ADMIN`.
  - The built-in Admin role definition holds that set, and `User.is_admin` compares against it, so Admin stays "an administrator" without the new permission.
  - The roles screen shows the permission as reserved to its role (like *Manage backups*).
- **Seed** the role in a migration: name "Access Privilege Approver", not portal, not editable beyond its members.
- **Rule location:** `core/privileged_access.py` gains "privileged and automatic", using the same routing question as execution (`ad_management` + COM-2179 protection; Entra role-write grant from COM-2182). Use it at approve, expedite and execute (re-check). `core/recert_requests.py` uses it for removals requests.
- **Self-assignment guard** on the role in the user/role assignment API; audited.
- **Polaris:** the approve tools refuse with the same reason; read tools say who can approve.

**Done when:** on staging:
- An Admin without the role sees "needs an Access Privilege Approver" on a request that would make a privileged change itself, and can't approve it. A member of the role (not the requester) can.
- The same request routed to a to-do is approvable by an Access Admin as today.
- An Admin can't give themselves the role once someone holds it.