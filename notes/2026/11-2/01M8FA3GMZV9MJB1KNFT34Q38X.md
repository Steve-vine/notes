---
id: 01M8FA3GMZV9MJB1KNFT34Q38X
created: 2026-11-27T20:10:47.327707Z
updated: 2026-11-27T20:50:34.330254Z
type: task
title: The built-in Admin role no longer says it is "everything", and the Entra card says how to let Compass change directory roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2201
sprint: smq8t5s
comments:
- id: 01M8FCCAS6BPHBMQ96EEKAT9Q3
  author: Steve Vine
  at: 2026-11-27T20:50:33.382757Z
  text: |-
    Done — merged to main in PR #2208. It goes to staging with the next deploy.

    Unlike the task body says, it needed a migration: Admin's description is stored, so a small data change (0952) replaces it, and only if it's still the original wording.

    What changes:
    - Admin ▸ Roles: the built-in Admin reads "Every permission but the few reserved to a built-in role of their own (Access Privilege Approver, Script Manager) — and Compass refuses to be left without a holder of it". Script Manager is the Scripting sprint's role, now on main.
    - The "Some rules are not permissions" note adds that those two permissions belong to one built-in role alone, so even Admin doesn't hold them; people are given those roles by name.
    - Admin ▸ Integrations ▸ Entra ID: while the directory-role permission isn't granted, the grey notice now says:
      - how to grant it: the application permission on the Access app, admin consent, scripts/entra/README.md;
      - that each change then needs an Access Privilege Approver;
      - that the app could make anyone a Global Administrator.

    Checks: tests for the how-to text and Admin's new description; Entra and roles suites pass (50); unit suite passes; all CI jobs passed.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
**Independent** (wording only — no migration; a route or schema description may change). Fix-forward for COM-2181 and COM-2182, found in Claude's pre-UAT pass on staging 30786db4f (27 Nov 2026).

## What's wrong
- **Admin ▸ Roles:** the built-in Admin role reads "Everything. The one built-in role — it is the whole catalogue". Since COM-2181 that isn't true: Access Privilege Approver is built in too, and Admin doesn't hold its permission. The "Some rules are not permissions" note doesn't mention it either.
- **Admin ▸ Integrations ▸ Entra ID:** without the role-write permission, the card shows only the generic grey "Optional permission not granted" line. COM-2182 asked for it to say how to grant it, and what granting it means.

## What people see once fixed
- Admin reads: "Every permission except the one reserved to Access Privilege Approver".
- The roles note says Access Privilege Approver is the one permission Admin never holds.
- Without the permission, the Entra card says:
  - Compass can't change directory roles, so every role change is a to-do for an admin;
  - to let it, grant RoleManagement.ReadWrite.Directory to the Access app in Entra and give admin consent (scripts/entra/README.md);
  - an app with it can make anyone a Global Administrator.

## Done when
On staging: Admin ▸ Roles shows the new Admin wording and note, and Admin ▸ Integrations ▸ Entra ID shows the "how to grant" line while the permission isn't granted.