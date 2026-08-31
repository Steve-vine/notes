---
id: 01M1BKBQ5NMRRJVYXQ78C96TQE
created: 2026-08-31T09:45:42.837053Z
updated: 2026-08-31T12:45:23.608537Z
type: task
title: The permission catalogue — the list of things a role can be allowed to do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 550
sprint: sz42uhw
assignee: steve
company: null
label:
- brief
priority: medium
task_status: done
---
The list of permissions an administrator ticks when defining a role. Decided with Steve on 2026-08-31; what remains is confirming the permission names and building it.

## Decisions

1. **Permissions are global, as today.** A role grants the same thing in every company. One team governs several companies here; per-company grants would touch every check, every list query and the admin screen, and can be added later if the shape of the business changes.
2. **Portal access is a structural boundary, not a permission.** Vendor contacts and recertifiers reach `/portal` and can never reach the internal app, whatever any role says. Portal accounts keep their small fixed set of portal abilities outside the custom-role system — an administrator cannot build a custom role that mixes portal and internal, because one mis-tick would expose internal Compass to an outside vendor.
3. **Write implies view within its area.** Ticking *Approve an access request* means you can see requests. Each area also has its own *View* permission for read-only roles. It is impossible to build a role that can act on something it cannot open.
4. **Admin is the only built-in role**, and it holds everything. Every other role is defined by an administrator. Admin cannot be edited into something that locks everyone out, nobody can remove their own last Admin grant, and the system refuses to leave itself with no Admin.
5. **Today's roles migrate as ordinary editable roles**, not as built-ins — each existing role becomes a role definition holding exactly the permissions it has now, so nobody loses access on the day it lands. They can then be renamed, merged or deleted like any other. Deleting a role in use states how many people it affects first.

## The catalogue

Five groups, named as the app names them (Vendor Management, Access Control and Admin already match the navigation). Permission names are the words on the screen, not endpoint names.

**Playbook**
- View the playbook
- Author playbook content — domains, controls, policies, standards, procedures, runbooks
- Manage frameworks and crosswalks
- Record decisions

**Posture**
- View posture — dashboard, assessments, gaps, risks
- Record assessments
- Manage gaps
- Manage risks and treatments
- Maintain the statement of applicability
- Run and export reports

**Vendor Management**
- View vendors
- Request a vendor
- Manage the vendor register
- Send and complete vendor questionnaires
- Decide vendor approvals
- Design vendor questionnaires

**Access Control**
- View access — directory, business roles, requests
- Raise an access request
- Approve an access request
- Edit a request at the gate
- Cancel someone else's request
- Raise an expedited (break-glass) change
- Validate an expedited change
- Approve a privileged change — one touching a role-assignable group
- Delete a directory account — the leaver deletion in COM-546
- Manage business roles and their group mappings
- Accept coverage proposals
- Run recertification campaigns
- Explain or reverse an unrequested change

**Admin**
- Manage companies
- Manage users
- Manage roles and permissions
- Manage integrations — Entra ID, email
- Manage sign-in group mappings
- Manage rubrics and levels — maturity, risk, criticality, data sensitivity, access levels
- Manage report definitions
- Manage configuration — extra fields, content types, approval areas, portal branding

Thirty-four, against thirteen today. The splits that matter most are in Access Control, where *write access* is currently one box covering raising, approving, gate-editing, cancelling, mapping roles and accepting proposals — six different jobs, and the reason the current roles feel blunt.

**Name loudly, and mark as dangerous in the UI**: raise expedited, approve privileged, delete a directory account, manage roles and permissions, manage users. These are the ticks that change who can change everything else.

## Not permissions

The catalogue must say so where they could be mistaken for one: the approver cannot be the requester; an expedited change cannot be validated by whoever made it; a privileged approval needs an Access Admin's name on it. These are rules about a person and a particular record, enforced regardless of what any role permits. Ticking *Approve an access request* for everybody does not make maker-checker go away — and the screen must not imply it might.

## What's left

- Confirm the permission names read right on screen (Steve).
- Write it into `brief/` as the reference the admin screen and the API are built from.
- Then COM-549 seeds these permissions and splits the call sites to match.
