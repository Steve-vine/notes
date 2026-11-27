---
id: 01M8EGERP5KEBTQB48Q453GS5K
created: 2026-11-27T12:42:33.029791Z
updated: 2026-11-27T12:43:07.857712Z
type: task
title: Compass changes Entra directory roles itself when its app has been given the permission — otherwise a to-do confirmed by the next Entra read
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2182
sprint: smq8t5s
blocked_by:
- 01M8EGE7NVV4QKKWT3C06JEJHP
- 01M8EED1JWZH5K8NNQBTA6ZDGZ
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**On the chain** (migration + API). Stacks on COM-2181 (Access Privilege Approver) and COM-2178 (to-dos say why they're manual; ADR 0182). COM-2183 (granting) and COM-2184 (leavers) build on this.

Steve's decision (27 Nov 2026): as with AD, Compass is **able** to change Entra directory roles, and the admin decides whether it may by what they grant Compass's Entra app. Today Compass only reads roles. ADR 0045 says it "never writes a role assignment", and every role change is done by hand.

## What people see
- **Admin ▸ Integrations ▸ Microsoft** shows a new line, **Change directory roles**. It says whether Compass's app has been given the permission, read from Compass's own Microsoft sign-in.
  - If granted, it warns plainly: "An app with this permission can make anyone, itself included, a Global Administrator. Microsoft can't limit it to particular roles."
  - If not granted, it says how to grant it.
- **With the permission, Compass makes these changes itself:**
  - a **recertification removal** of a role holder: the active or eligible assignment is removed, and the review row closes when the next Entra read (every 15 minutes) no longer shows it. **Confirm removed** remains only for to-dos;
  - **undoing an unrequested role assignment** made straight to a person;
  - **membership changes to groups that grant roles**, already allowed with privileged approval but refused by Microsoft today.
- **Without it,** each becomes a to-do saying "Compass's app can't change directory roles", in Actions as today, and closes itself when the next Entra read shows the change. No more relying on **Confirm removed** alone.
- **Approval:** any of these that Compass will make itself needs an **Access Privilege Approver** (COM-2181). When it's a to-do, approval is as today.
- **Exception — business roles** still can't grant directory roles (ADR 0061).

## Notes (technical)
- **ADR 0184**, superseding ADR 0045's "never writes a role assignment" (and the matching line in ADR 0061 §5's notes), referring to ADR 0182's rule and ADR 0183's approver.
- **Graph:** `RoleManagement.ReadWrite.Directory` (application). Removal:
  - active, direct: `DELETE /roleManagement/directory/roleAssignments/{id}`;
  - PIM: `POST /roleManagement/directory/roleAssignmentScheduleRequests` / `roleEligibilityScheduleRequests` with `action: adminRemove`.
  - Role-assignable group membership needs the same permission.
- **Grant detection:** decode the app token's `roles` claim (see the *Entra grant vs token cache* memory: a new grant needs a fresh token). Store on the sync status like the other read/write availabilities.
- **Routing:** a function in the same place as `ad_management`, returning automatic or manual with a reason. COM-2181's "privileged and automatic" uses it.
- **Confirmation:** the 15-minute role pass (`_fetch_directory_roles` + COM-850's activation read) closes the step or recert row when the assignment is gone.
- **Docs:** `docs/microsoft-graph/README.md` and `scripts/entra/README.md` list the optional permission and its risk.

**Done when:** on staging:
- Without the permission, the Integrations line says "not granted", and a flagged role holder's removal becomes a to-do that closes itself after removing it by hand in Entra.
- With the permission granted on a test role and holder, approved by an Access Privilege Approver, Compass removes it and the row closes on the next Entra read.

(The second part needs the permission granted in the staging tenant — mark it Couldn't check if not.)