---
id: 01M8EGE7NVV4QKKWT3C06JEJHP
created: 2026-11-27T12:42:15.611185Z
updated: 2026-11-27T20:08:25.960656Z
type: task
title: Access Privilege Approver — only its members can approve a privileged change Compass will make itself; the one role Admin doesn't hold
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2181
sprint: smq8t5s
comments:
- id: 01M8ENKSVDH9M0VS457ZDHD6PP
  author: Steve Vine
  at: 2026-11-27T14:12:40.941703Z
  text: |-
    Built — PR #2188, merged to main as 0749b8e2c (not yet on staging; goes with the sprint deploy). ADR 0183 added and marked Accepted on your decision in this task — worth a read.

    What changed:
    - New built-in role **Access Privilege Approver** with one permission, "Approve privileged changes Compass makes itself". Admin doesn't include it and no other role can tick it (the roles screen greys it: "Access Privilege Approver only"). The role itself can't be edited or deleted, only who holds it. Nobody holds it after the upgrade.
    - A privileged change Compass will make itself (an Entra directory role, a group that grants one, an object AD protects) can be approved only by a member of the role who didn't raise it — even with Approve their own requests. The request page says "Compass will make this change itself — it needs an Access Privilege Approver" and greys Approve & execute for everyone else. Break-glass on such a change also needs the role. A review owner who signed it off can't approve its privileged removals.
    - Safety net: if Compass gains a right after an ordinary approval, it won't make the privileged change on that approval.
    - Giving the role: anyone who can manage users, never to themselves, except the very first holder. A sign-in group mapping that would give it to a group its editor is in is refused. Every grant and removal goes in the activity log. Polaris says when the role is needed and whether one approved.

    Important for checking: **nothing is automatic yet**. Compass only makes these privileged changes itself once COM-2179 (AD protected objects) and COM-2182 (Entra role writes) give it the rights, so until those land the Access Admin gate works exactly as today. The "Done when" items about a request needing an Access Privilege Approver can only be seen on staging after 2179/2182; the role, the reserved tick and the self-grant rule can be checked now.

    One part deferred: "This will be a to-do for an admin" on the request page — only true once 2179/2182 route those changes to to-dos, so it comes with them.

    If your own production account is Entra-provisioned, the role reaches you through a sign-in group mapping (the very first holder may set that up for a group they're in).
- id: 01M8F9Z6K8ZJBPF147HM59N8SC
  author: Steve Vine
  at: 2026-11-27T20:08:25.960266Z
  text: |-
    Pre-UAT on staging 30786db4f: Passed (the role, the reserved permission, no self-grant); Couldn't check (the approval gate, since nothing is automatic on staging).

    Steps and what I saw, as E2E Admin A:
    - Admin ▸ Roles lists "Access Privilege Approver — Built in". It has 1 permission and 0 holders, and its Edit and Delete are greyed. Description: "Approves the privileged changes Compass makes itself… Admin does not include it, and nobody can give it to themselves."
    - Admin has 95 permissions. In the Edit Access Admin dialog, "Approve privileged changes Compass makes itself" is greyed with the badge "Access Privilege Approver only" and the explanation "not even Admin has it". I pressed Cancel; nothing was saved.
    - Admin ▸ Users: Admin A's own Roles field is disabled, so no one can give themselves the role here. For Admin B, the roles list offers Access Privilege Approver. I closed it with Escape without choosing anything, and Admin B stayed Admin only.
    - On ACR-207, a request with a directory role, Admin B was offered Approve & execute, with "needs an Access Admin: it changes directory roles: Message Center Reader". That's right for a change that will be a to-do, because the Entra role-write permission isn't granted. I rejected it.

    Couldn't check:
    - "Compass will make this change itself — it needs an Access Privilege Approver", and the greyed approve button for everyone else. On staging, AD has no AdminSDHolder rights and Entra has no role-write permission, so no change is automatic.
    - An Admin being refused the role once someone holds it. Nobody holds it, and making a test account the first holder would change staging's set-up.
    Also not shown: the line "This will be a to-do for an admin", which you deferred to 2179/2182. It doesn't appear on ACR-207 either.

    Minor wording (not blocking):
    - The built-in Admin role's description still reads "Everything. The one built-in role — it is the whole catalogue". There are now two built-in roles, and Admin no longer holds everything.
    - The roles screen's "Some rules are not permissions" note doesn't mention the Access Privilege Approver rule.

    Screenshots: ~/compass-uat/sprint-128/COM-2181/ (01 roles list, 02 reserved permission greyed).
assignee: steve
label:
- feature
priority: high
task_status: review
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