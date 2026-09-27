---
id: 01M3GVN4EQR218NFV03QCD6EHB
created: 2026-09-27T07:18:15.767231Z
updated: 2026-09-27T08:05:20.177423Z
type: task
title: A role can grant a Microsoft 365 group, as a deliberate choice, with a warning that its owners lose self-service
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 770
sprint: ss8v7d0
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Follow-up to COM-764 (ADR 0080), 2026-09-27.

COM-764 widened what a business role can map to security groups, distribution lists and mail-enabled security groups. Microsoft 365 groups were left out. That was a scope choice, not a technical limit:
- Graph can change an M365 group's membership directly, as it does for security groups. No Exchange session is needed.
- M365 groups are always cloud groups, so no AD to-dos are involved.

The reason to be careful is how they're used. Staging has 885 assigned M365 groups, most of them Teams:
- **Team owners add and remove members themselves**, without asking anyone.
- **Membership grants more than access**: the team's chat, SharePoint site, calendar and Planner.

## What people see

- **Role editor.** The picker also offers **Microsoft 365** groups (assigned membership only; dynamic groups stay out), with a **Microsoft 365** type pill (see COM-769).
- **Mapping one asks first.** Before the save, a confirmation says:
  > *"Sales Team is a Microsoft 365 group, and probably a Team. Once a role maps it, Compass governs its members. When an owner adds or removes someone in Teams, that becomes an unrequested change for someone to explain. Its owners and guests are not managed. Map it anyway?"*
  The usual role-edit preview (ADR 0064) follows.
- **Joiners, movers and leavers** gain and lose a mapped M365 group like a security group, through Graph.
- **An ad-hoc membership request** can name one, as an exception, the same way it can name a group.
- **Only members are managed.** Owners and guests are never added or removed. A leaver who *owns* a mapped M365 group loses their membership, and the request says they still own it.

## Out of scope

- Creating, deleting or archiving Teams and M365 groups.
- Managing owners, guests, the group's visibility, or its expiry.

## Notes

- **ADR:** amends ADR 0080 §1 by adding `m365` to the governable types, and records the owner-self-service consequence.
- `GOVERNABLE_GROUP_TYPES` gains `m365`. It is written through Graph, so `is_list` stays false for it. Deletion stays with plain security groups, and SSO mappings stay security-only.
- The confirmation comes from the frontend on the kind of group. The API accepts the mapping; there's no second server gate.
- Check the member-count and graph screens read M365 groups correctly as governable.
- **Related:** COM-771 (choosing what is watched for unrequested changes) lets an organisation that manages M365 groups elsewhere switch off tracking for them, and Compass warns if a managed group's type isn't tracked.

**Done when:** a role maps an M365 group after the confirmation. A joiner is added through Graph, a leaver is removed, and a leaver who owns the group is told they still do. Tests cover the widened surface and that deletion and SSO still refuse M365 groups.