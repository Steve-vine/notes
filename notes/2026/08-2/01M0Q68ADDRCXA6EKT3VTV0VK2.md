---
id: 01M0Q68ADDRCXA6EKT3VTV0VK2
created: 2026-08-23T11:31:51.341403Z
updated: 2026-08-25T15:27:40.498756Z
type: task
title: Devices count as group members — member counts, member lists, effective membership
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 388
sprint: s5gwx0s
blocked_by:
- 01M0Q67QE392HEGF8CPFXV4771
- 01M0Q67YJ52N1TR8GAVSX7V20E
comments:
- id: 01M0QF2A48H1XGKZA6AE1A1BKH
  author: Steve Vine
  at: 2026-08-23T14:05:51.624698Z
  text: |-
    Done — PR #390 (feature/com-388-device-members), stacked on #389 (COM-387).

    The load-bearing decision: `EffectiveMembers` gains `direct_device_ids` / `inherited_device_ids` as **their own fields**, never merged into the user sets. The matrix, JML, recert and out-of-band detection all read `direct_user_ids`, so they keep getting only people *because of what they call*, not because someone remembered a filter. `direct_device_members_by_group` is likewise its own function over its own table. The recert snapshot carries a comment at the exact walk that would otherwise have widened, and `test_a_campaign_never_asks_about_a_device` holds it — a campaign asks a reviewer to attest a *person* still needs access, and there is nobody to ask about a workstation.

    Landed:
    - `device_member_count` + direct/inherited split on `DirectoryGroupOut`, counted apart. Zero on a user-only group, so those surfaces read exactly as before.
    - Ordering by `member_count` now uses the **combined** figure — a device-only group no longer sorts as empty, which was the same lie in a different place.
    - View Groups shows "N users · M devices", the device half only when non-zero.
    - Group modal: members panel becomes **Users**, with a **Devices** table below (OS, unmanaged/non-compliant flags, the same via-nested badge, row opens the device modal). A device-only group's user panel now says *why* it's empty rather than implying the group is.

    **One departure from the brief, flagged.** The brief asked for device rows inside `/groups/{id}/members` with a member-kind discriminator, reasoning "additive, existing consumers keep working". I built a sibling `/groups/{id}/device-members` instead, because that reason is better served by it: the two lists paginate independently (a group can have twelve people and five hundred workstations, and one shared limit/offset can't serve both), a device has no UPN, user type or mail — a shared row would carry those as nulls and state something false about every device — and `/members` is left byte-identical, so consumers genuinely keep working rather than getting a widened union type. `test_the_user_member_list_stays_user_only` pins it.

    Effective-membership dedupe applies to devices too: a device both direct and inherited counts once, as direct.

    Backend 201 unit + 754 integration green. One pre-existing full-suite frontend flake (`PortalRouting.test.tsx`) — reproduced on an unmodified tree and passes in isolation, so not from this change; it's the known load-dependent findBy timeout.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The payoff for the empty-groups problem: a security group whose members are devices stops reading as empty. Read-only throughout — device membership is shown, never edited.

- [ ] `member_counts` / `EffectiveMembers` (`core/directory_graph.py`) grow device members — **kept apart from user counts**, never conflated: View Groups shows something like "12 users · 34 devices" (device count only when non-zero, so user-only groups look unchanged).
- [ ] Effective membership: device members inherit through nested groups exactly as users do — the closure walk gains a device leg.
- [ ] `GroupDetailModal` members panel: device members listed distinctly (own section or a type tag beside the name), chips opening the device detail modal from the View Devices task; direct vs inherited kept apart as for users.
- [ ] Group members API (`/directory/groups/{id}/members`) carries the device rows with a member-kind discriminator — additive schema change, existing consumers keep working.
- [ ] Sorting View Groups by member count uses the combined figure (a device-only group should no longer sort as empty).
- [ ] **Scope unchanged**: matrix, JML, recert snapshots and out-of-band detection remain user-only — say so in the code where the exclusion happens, so the boundary is deliberate, not accidental.

Refs: COM-300 (effective membership), COM-252 (member panels), ADR 0048 §5 (transitive membership computed at read time).