---
id: 01M8FA3GMZV9MJB1KNFT34Q38X
created: 2026-11-27T20:10:47.327707Z
updated: 2026-11-27T20:10:47.327707Z
type: task
title: The built-in Admin role no longer says it is "everything", and the Entra card says how to let Compass change directory roles
priority: medium
label: improvement
assignee: steve
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2201
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