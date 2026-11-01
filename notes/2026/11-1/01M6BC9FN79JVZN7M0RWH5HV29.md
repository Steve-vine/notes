---
id: 01M6BC9FN79JVZN7M0RWH5HV29
created: 2026-11-01T11:00:38.695651Z
updated: 2026-11-01T13:26:23.569402Z
type: task
title: Entra group mappings can't grant Vendor Approver, or any other role that another screen hands out
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1506
sprint: s53765q
comments:
- id: 01M6BMMAG5EKGY8G5BTNMP1KWJ
  author: Steve Vine
  at: 2026-11-01T13:26:22.468879Z
  text: |-
    Done: PR #1523 merged (migration 0755_mappings_drop_owned_portal).
    - The group mapping screen greys Vendor Approver, Asset owner, Recertifier and Attester, saying which screen grants each, and the API refuses them. Vendor Requester can still be mapped.
    - Found on the way: when Compass recalculated an Entra user's roles, it removed Vendor Approver unless a group granted it. So an approver named on an area would have lost the role (which deciding needs) without the compass-vendormanagers grant. The recalculation now keeps Vendor Approver for anyone named on an approval area, whatever their groups. Tested.
    - The migration removes the four roles from every mapping, writes an activity-log line for each mapping it touched, and takes Vendor Approver from Entra accounts named on no area.
    - Nobody who could decide a request loses that.
    - ADR 0046 amended.
    Pre-UAT (read-only) after the staging deploy.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint 101, Roles and Permissions. Raised by Steve on 1 Nov 2026.

## What happens

Vendor Approver is meant to follow approval areas. You get it when you're named as an approver on a Vendors ▸ Approval area, and lose it when you come off the last one. The Users screen already refuses to grant it by hand for that reason. But the Entra group → role mapping screen still accepts it. On staging, **compass-vendormanagers** grants Vendor Approver alongside Vendor Admin.

What that does:
- Every member of the group shows as a Vendor Approver, whether or not they're named on any area.
- It doesn't let them decide anything more. A request can only be decided by someone named on its area, or by an admin.
- The role can't be taken back by coming off an area, because the group grants it again at the next sync.

So the role stops meaning "approves vendor requests in some area", which is the one thing it's for.

## Behaviour

- The mapping screen doesn't offer **Vendor Approver**, nor the other roles another screen hands out: **Asset owner**, **Recertifier** and **Attester** (assumption, stated for Steve: the same rule for all four). Each greyed option says which screen grants it, as the Users screen does. The API refuses them too.
- Vendor Contact is still allowed in a mapping, because no other screen grants it.
- **Existing mappings:** a new migration removes those four roles from every group mapping, on staging and production. Everyone's roles are then recalculated. A person keeps Vendor Approver only if they're named on an approval area, and likewise for the other three. The change appears in the activity log against each mapping it touched.
- Nobody can decide less than before, because deciding already needed naming on the area.

**Chain:** on the chain (a migration plus an API refusal).

**Done when:**
- The mapping screen and the API both refuse Vendor Approver, Asset owner, Recertifier and Attester, saying where each is granted.
- After the migration, compass-vendormanagers grants Vendor Admin only. Its members who aren't named on any approval area no longer hold Vendor Approver, and those who are named still do.
- Every vendor request that someone could decide before can still be decided by the same people.
- Pre-UAT: read-only for mappings, because they drive real sign-ins. As E2E Admin A, open Users ▸ Entra group → Role mapping, start adding a mapping (cancel without saving), and check the four roles are greyed with their explanation. Check the compass-vendormanagers mapping no longer lists Vendor Approver.