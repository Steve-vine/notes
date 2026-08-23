---
id: 01M0Q68ADDRCXA6EKT3VTV0VK2
created: 2026-08-23T11:31:51.341403Z
updated: 2026-08-23T11:32:13.376776Z
type: task
title: Devices count as group members — member counts, member lists, effective membership
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 388
sprint: s5gwx0s
blocked_by:
- 01M0Q67QE392HEGF8CPFXV4771
- 01M0Q67YJ52N1TR8GAVSX7V20E
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The payoff for the empty-groups problem: a security group whose members are devices stops reading as empty. Read-only throughout — device membership is shown, never edited.

- [ ] `member_counts` / `EffectiveMembers` (`core/directory_graph.py`) grow device members — **kept apart from user counts**, never conflated: View Groups shows something like "12 users · 34 devices" (device count only when non-zero, so user-only groups look unchanged).
- [ ] Effective membership: device members inherit through nested groups exactly as users do — the closure walk gains a device leg.
- [ ] `GroupDetailModal` members panel: device members listed distinctly (own section or a type tag beside the name), chips opening the device detail modal from the View Devices task; direct vs inherited kept apart as for users.
- [ ] Group members API (`/directory/groups/{id}/members`) carries the device rows with a member-kind discriminator — additive schema change, existing consumers keep working.
- [ ] Sorting View Groups by member count uses the combined figure (a device-only group should no longer sort as empty).
- [ ] **Scope unchanged**: matrix, JML, recert snapshots and out-of-band detection remain user-only — say so in the code where the exclusion happens, so the boundary is deliberate, not accidental.

Refs: COM-300 (effective membership), COM-252 (member panels), ADR 0048 §5 (transitive membership computed at read time).