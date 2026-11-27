---
id: 01M8EEDKP3FVQVTJHF9804NJQR
created: 2026-11-27T12:06:57.987329Z
updated: 2026-11-27T12:06:57.987329Z
type: task
title: Compass knows which AD groups and accounts AD protects — and changes them only if its account has been given rights on protected objects
label: feature
task_status: todo
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2179
---
**On the chain** (migration + API). Stacks on COM-2178 (refusals become to-dos; ADR 0182). Goes with COM-2180 (built-in containers can be ticked).

AD protects its admin groups and everything in them. Every hour it resets their permissions from a template, AdminSDHolder, so rights granted on an OU don't apply to them. In Moneypenny's AD (read 27 Nov 2026) that's:
- the 13 built-in groups: Domain Admins, Administrators, Enterprise Admins, Schema Admins, Account Operators, Print Operators, Backup Operators, Server Operators, Replicator, Key Admins, Enterprise Key Admins, Domain Controllers, Read-only Domain Controllers;
- groups nested in them: **Domain Server Access** (19 members) and **Domain Power Users**, both inside a managed OU, and Exchange Trusted Subsystem;
- **32 accounts**, 29 of them in MyBusiness, including people who have since left these groups. AD keeps the mark on an account after it leaves.

Today Compass doesn't know any of this. It tries changes to those objects as if the OU's rights applied, and AD refuses.

Steve's decision (27 Nov): whether Compass may change protected objects is the admin's choice, made by what they grant Compass's AD account. If it hasn't been granted, the change is a to-do.

## What people see
- **A person or group popup** shows a **Protected by AD** pill on anything AD protects, with one line: "AD manages this object's permissions itself; Compass changes it only if its account has rights on protected objects."
- **Access Control ▸ Admin ▸ Active Directory** gains a **Protected objects** line beside the managed OUs. It says what Compass's account may do there, from the same rights check as an OU: change groups, change accounts, change senders. It also counts the protected groups and accounts, with a link to see them. If nothing has been granted, it says how: rights for Compass's account on the AdminSDHolder object, with a warning that this puts Compass's account on a par with a domain admin.
- **Routing a change:**
  - If Compass's account has the right on protected objects, Compass makes the change, like any other.
  - If not, the change becomes an on-prem to-do **before anything is tried**, reading "Protected by AD — Compass's account has no rights on protected objects" (COM-2178's reason).
  - This applies to every kind of change: membership, leaver disable and delete, detail changes, send on behalf.
- **No longer protected:** an account AD no longer protects, because someone cleared the mark, is routed by its OU again on the next AD read.

## Notes (technical)
- **Read `adminCount`** on users and groups in the AD read (`core/ad_reader.py`) and mirror it (`ad_protected` boolean on the AD-side user/group rows). AD's own background process sets it for nested members, so no Compass-side nesting logic is needed. Treat `adminCount=1` as protected even after the object leaves the group: the permissions stay frozen until someone resets them.
- **Rights on protected objects:** run the existing OU rights check (`core/ad_scope.py`, `_effective` / `OuRights`) against `CN=AdminSDHolder,CN=System,<domain>`, and store it like a managed OU's rights (a "protected objects" scope row). Re-check on the same cadence as the OUs.
- **`ad_management()`** gains: if the object is protected, use the AdminSDHolder rights, whatever its OU. Membership changes need the right on the **group**. Account changes (disable, delete, update, send on behalf) need it on the **account**.
- **ADR:** append a section on protected objects to ADR 0182 (COM-2178).
- **Polaris:** the person and group read tools say "protected by AD".

**Done when:** on staging:
- Domain Server Access and a protected account show **Protected by AD**.
- Admin ▸ Active Directory shows the Protected objects line with its rights and counts.
- With no AdminSDHolder rights for Compass's account, a membership change to Domain Server Access becomes a "Protected by AD" to-do instead of failing.