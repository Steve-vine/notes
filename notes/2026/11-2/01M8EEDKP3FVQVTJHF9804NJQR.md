---
id: 01M8EEDKP3FVQVTJHF9804NJQR
created: 2026-11-27T12:06:57.987329Z
updated: 2026-11-27T22:31:18.290518Z
type: task
title: Compass knows which AD groups and accounts AD protects — and changes them only if its account has been given rights on protected objects
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2179
sprint: smq8t5s
blocked_by:
- 01M8EED1JWZH5K8NNQBTA6ZDGZ
- 01M8EGE7NVV4QKKWT3C06JEJHP
comments:
- id: 01M8EGG3964VBRETBSRCYZRQAV
  author: Steve Vine
  at: 2026-11-27T12:43:16.646714Z
  text: 'Added 27 Nov (Steve): a change to a protected group or account that Compass will make **itself** (its account has rights on protected objects) needs an **Access Privilege Approver** to approve it — COM-2181, which this now waits on. When it becomes a to-do instead, approval is as today. The Protected objects line on Admin ▸ Active Directory should say so: "Changes Compass makes here need an Access Privilege Approver."'
- id: 01M8ESGMKEXBPTZ9XTFJ6F8JKG
  author: Steve Vine
  at: 2026-11-27T15:20:51.565909Z
  text: |-
    Built — PR #2190, merged to main as 5daaf39d2 (not yet on staging; goes with the sprint deploy). ADR 0182 gains §4 on protected objects.

    What changed:
    - Compass reads AD's protection mark (adminCount) on every user and group. The upgrade makes the next AD read a full one, so every protected object is marked straight away. The person and group popups show a **Protected by AD** pill with the line you specified; Polaris's person/group tools say it too.
    - **Admin ▸ Active Directory ▸ Protected objects**: Compass's rights there (change groups / accounts / senders, from the same check as the OUs, on the same cadence), how many groups and accounts AD protects, and — when nothing is granted — how to grant it (rights on AdminSDHolder) with the domain-admin warning. When something is granted it says "Changes Compass makes here need an Access Privilege Approver."
    - Routing: a protected object in a ticked OU goes by the rights on protected objects, not the OU's. Without them the change is a to-do **before anything is tried**: "Protected by AD — Compass's account has no rights on protected objects". With them, Compass makes it — but only on an **Access Privilege Approver's** approval (COM-2181): the request page asks for one, and if a request reaches AD without it, the change goes to a person ("…only on an Access Privilege Approver's approval"). Covers membership, leaver disable and delete, detail changes, send on behalf.
    - An object AD no longer protects is routed by its OU again after the next AD read.

    Choices I made:
    - A protected object still has to sit in a **ticked OU** (or container, COM-2180) for Compass to touch it — the tick says where Compass may act at all, the rights say whether it can. Your note said "whatever its OU"; I read that as "the OU's rights don't count", not "outside the ticked OUs too". Say if you meant the latter.
    - "Rights not checked yet" counts as no rights for protected objects (a to-do, not a try).
    - Not done: the "link to see them" from the Protected objects counts — the people/group lists have no protected filter yet, and adding one is an API change. Easy follow-up if you want it.

    For pre-UAT: Domain Server Access and a protected account should show the pill after staging's first full read.
- id: 01M8F9YS6SQZ9B8KAWZ3S0S033
  author: Steve Vine
  at: 2026-11-27T20:08:12.24939Z
  text: |-
    Pre-UAT on staging 30786db4f: Passed (on screen); Couldn't check (the to-do needs an approved change).

    Steps and what I saw, as E2E Admin A:
    - Access Control ▸ Groups ▸ Domain Server Access popup: a Protection line with the "Protected by AD" pill and "AD manages this object's permissions itself; Compass changes it only if its account has rights on protected objects." Changes in AD: "Protected by AD, and Compass's account has no rights on protected objects — changes are to-dos".
    - Domain Admins popup: same pill. It sits in CN=Users, so Changes in AD reads "Outside the OUs Compass manages".
    - Protected account: Access Control ▸ Users ▸ Nessus Scan (a Domain Admins member, in a MyBusiness OU) shows the same pill and the protected routing line.
    - Admin ▸ Integrations ▸ Active Directory ▸ Configure: a Protected objects line beside Managed OUs. "AD protects 16 groups and 53 accounts — its admin groups, groups nested in them, and their members. Their permissions come from AdminSDHolder, not their OU." Then "Change groups: no / Change accounts: no / Change senders: no", and the how-to with the domain-admin warning (rights on CN=AdminSDHolder,CN=System).
    - As noted in your comment, there is no link from the counts to the protected groups and accounts.

    Couldn't check: a membership change to Domain Server Access becoming a "Protected by AD" to-do instead of failing. That needs an approved request, which would run against the real AD.
    For Steve: approve a test change to Domain Server Access (or a test protected group) and check that the request waits on a to-do with that reason.

    Screenshots: ~/compass-uat/sprint-128/COM-2179/ (01 protected-objects line, 02 Domain Server Access, 03 Domain Admins, 04 protected account).
assignee: steve
label:
- feature
priority: medium
task_status: done
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