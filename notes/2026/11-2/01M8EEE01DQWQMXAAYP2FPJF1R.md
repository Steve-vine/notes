---
id: 01M8EEE01DQWQMXAAYP2FPJF1R
created: 2026-11-27T12:07:10.637565Z
updated: 2026-11-27T20:08:17.320949Z
type: task
title: AD's built-in containers (Users, Builtin and the like) can be ticked for Compass to manage, like an OU
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2180
sprint: smq8t5s
comments:
- id: 01M8EW61Y3PRCGRS9A23DW5YJZ
  author: Steve Vine
  at: 2026-11-27T16:07:30.499205Z
  text: |-
    Built — PR #2191, merged to main as 42b93dd55 (not yet on staging; goes with the sprint deploy).

    What changed:
    - Admin ▸ Active Directory now lists the domain's built-in containers alongside the OUs — Users, Builtin, Computers, and any other top-level container someone lives in — each marked **Container**. AD's own machinery (System, Program Data, ForeignSecurityPrincipals…) isn't offered. They appear after the next AD read.
    - Ticking a container works exactly like ticking an OU: Compass checks what its account may do there and shows it; changes to objects inside are made by Compass with the right, or become a to-do with its reason (COM-2178).
    - A container holding protected groups says so: "N of the groups here are protected by AD — see Protected objects" (those also need the rights on protected objects, COM-2179).
    - Builtin is never offered as where new starters go (AD refuses user accounts there), as the default or on a role, and is refused if sent.
    - The AD setup notes (docs/active-directory) now cover containers, protected objects and refusals becoming to-dos.

    Done-when on staging: after the next AD read, Users/Builtin/Computers should appear as containers; ticking Users runs its rights check.
- id: 01M8F9YY5879E0JY6N87NRW17Y
  author: Steve Vine
  at: 2026-11-27T20:08:17.320579Z
  text: |-
    Pre-UAT on staging 30786db4f: Passed (the list); Couldn't check (ticking a container, and a change inside one).

    Steps and what I saw, as E2E Admin A: Admin ▸ Integrations ▸ Active Directory ▸ Configure ▸ Managed OUs, expanded "Organisational units 454" (it was 449 OUs before; the rest are the containers).
    - Builtin, Computers, Managed Service Accounts, Microsoft Exchange System Objects and Users each carry a CONTAINER mark. Domain Controllers and Microsoft Exchange Security Groups are real OUs and correctly have no mark.
    - Builtin: "6 of the groups here are protected by AD — see Protected objects".
    - Users: "7 of the groups here are protected by AD — see Protected objects".
    - System, Program Data and ForeignSecurityPrincipals aren't offered.
    - I only looked, as instructed. Nothing was ticked.

    Couldn't check:
    - ticking Users and seeing its rights check;
    - a membership change to an unprotected group in a ticked container being made by Compass.
    Both change what Compass may do in the real AD. For Steve: tick Users (or Computers) yourself, check that the rights line appears beside it, then untick it if it isn't wanted.

    Screenshots: ~/compass-uat/sprint-128/COM-2180/ (01 Builtin and Computers, 02 Users).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain** (probably a migration so the OU list can hold containers too). Goes with COM-2178 (refusals become to-dos) and COM-2179 (protection).

Today **Access Control ▸ Admin ▸ Active Directory** lists only real OUs (449 in Moneypenny's AD). AD's built-in containers aren't OUs, so they can never be ticked:
- **CN=Users**: Domain Admins, Enterprise Admins, Schema Admins, Key Admins, Domain Controllers…
- **CN=Builtin**: Administrators, Account Operators, Print Operators, Backup Operators, Server Operators, Replicator.
- **CN=Computers**: the default home of new computer accounts.

Changes to anything in them are always to-dos. Steve's decision (27 Nov 2026): Compass offers every place in AD, and the admin decides by ticking it and granting rights.

## What people see
- **The list includes containers:** the Admin ▸ Active Directory list of places Compass may manage shows the domain's built-in containers alongside the OUs: Users, Builtin, Computers and any other top-level container holding users or groups. Each is marked *Container* so it's not mistaken for an OU.
- **Ticking a container** works exactly like ticking an OU. Compass checks what its account may do there (change groups, change accounts, create accounts, change senders) and shows the result. Changes to objects in a ticked container with the right are made by Compass. Without the right, each change becomes a to-do with its reason (COM-2178).
- **Protected objects:** most of what sits in Users and Builtin is also protected by AD (COM-2179). Ticking the container alone isn't enough for those; they also need the rights on protected objects. The container's line says so when it holds protected objects: "12 of the groups here are protected by AD — see Protected objects."
- **Joiners:** a container can be chosen as a role's new-starter location only if it allows creating accounts. Builtin never does, since AD refuses user accounts there; it isn't offered.

## Notes (technical)
- `_OU_FILTER = "(objectClass=organizationalUnit)"` in `core/ad_reader.py` limits the read. Also read the domain root's child `container` objects (`(objectClass=container)`, one level, plus `builtinDomain` for CN=Builtin). Store them in `directory_ous` with a kind column (ou / container / builtin), or a sibling table if cleaner. Skip system containers that hold no users or groups (System, Program Data, ForeignSecurityPrincipals, etc.), or show them only if they do.
- `innermost_managed_ou` / `dn_within` already work on any DN, so routing needs no change once a container can be a `ManagedOu`.
- The rights check (`ou_rights`) works on any DN; check `allowedChildClassesEffective` for containers too, which decides whether accounts can be created there.
- Keep the AD setup notes in step: the delegation steps for a container are the same as for an OU.

**Done when:** on staging:
- Admin ▸ Active Directory lists Users, Builtin and Computers as containers.
- Ticking Users shows its rights check.
- A membership change to an unprotected group in a ticked container is made by Compass. (A protected one follows COM-2179.)