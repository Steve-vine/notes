---
id: 01M4DYN4XTHBG1KPXA8MC6BRN4
created: 2026-10-08T14:28:40.506141Z
updated: 2026-10-09T16:25:22.910542Z
type: task
title: The move form can add a group — "Add a group" under Membership diff (manual groups), with a type-to-filter lookup
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 874
sprint: sme8esk
blocked_by:
- 01M4DYMJCCRY0G6ZFJFBDKQ8T2
comments:
- id: 01M4DYV4KHBEEHQCBZHDBPYKM9
  author: Steve Vine
  at: 2026-10-08T14:31:56.785459Z
  text: |-
    Correction, 2026-10-08 — the lookup's fourth exclusion, "a group Compass isn't allowed to change", is not a separate category. Checked against the code (DirectoryGroup.governable, _writable_or_refuse): the only groups Compass will not change are dynamic ones, which the list already excludes by name. Security groups, Microsoft 365 groups, distribution lists and mail-enabled security groups can all be added.

    So the lookup leaves out three things: groups the person is already in, groups a role on the form already grants, and dynamic groups. A group that grants an Entra admin role IS offered, marked as such, and picking it means the request needs an Access Admin's approval (as the body already says).
- id: 01M4EPMEYJWZBT1PXFX6AGVAAP
  author: Steve Vine
  at: 2026-10-08T21:27:43.826606Z
  text: |-
    Done — PR #872, merged to main 2026-10-08. Not yet on staging (deploys with the rest of the sprint).

    What changed on the move form:
    - "Add a group" at the bottom of Membership diff (manual groups). Type to search; each result shows its description. Picking one adds a green "+ group" pill.
    - A green pill opens a box: what the group is, that this request is what approves it, and "Don't add".
    - The lookup leaves out groups they are already in, groups the roles on the form are about to give them, ones already picked, and dynamic groups.
    - A group that grants Entra admin roles is offered, marked, and needs an Access Admin's approval.
    - The approver sees them under "Manual groups added". Once run, the group is theirs as approved on this request, and survives their next move.

    Departure from the task: no new column — the request's existing "groups to join" list is used, so there is no migration.

    To check on staging after deploy: open a move, add a group from the lookup, raise and approve; the person is in the group, and it shows as approved on that request when you click it on their next move.
- id: 01M4GEN9QG305RSRKPA3ATR0KJ
  author: Steve Vine
  at: 2026-10-09T13:46:51.503973Z
  text: On staging 2026-10-09 (5161e64a).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Asked for by Steve testing access control on staging, 2026-10-08: "in the Membership diff (manual groups) section add a button at the bottom to add a group. This should display a lookup box that the user can type in to filter the list of possible groups and add one."

**Blocked by COM-873** (the Membership diff (manual groups) section and its click-to-open box). The ADR written there covers this task too.

## What people see

- At the bottom of **Membership diff (manual groups)**: an **Add a group** button.
- It opens a **lookup box**. Typing filters the list of groups; each result shows the group's name and description. Picking one adds it to the section as a green "+ group" pill and closes the box. The button is there again to add another.
- **Click a green pill** → the box with the group's description and **Don't add**, which takes it back out.
- The lookup doesn't offer groups that make no sense to add:
  - a group the person is already in;
  - a group one of the roles on the form already grants (it is coming anyway);
  - a dynamic group — a rule decides who is in it;
  - a group Compass isn't allowed to change.
- A group that grants a **privileged role** follows the same extra-approval rule it does on "Change access" — the form says so when one is picked.
- Removing a manual group and adding the same one back in one request cancels out: it returns to Manual groups.
- The approver sees the additions listed by name on the request. When it runs, the person is added, and from then on the group shows in their Manual groups as **approved on this request**.
- A move that only adds a group — nothing else changed — can be raised.

## How (implementation)

**Backend**
- A mover subject gains `add_group_ids` (JSON list, beside `drop_group_ids`; migration, append-only).
- Validation at raise: exactly what `membership_change` applies to a **join** — governable groups, dynamic refused, privileged gate, present in the mirror. Factor that check out and call it from both kinds rather than copying it.
- The run: grant through the same path a `membership_change` join uses (`tasks/access_execute.py` ~2270–2311), which records `MembershipProvenance.exception` with the request id — so on-premises groups become an AD write or a to-do and Exchange-managed lists go the Exchange way, with no second implementation. Run order within a mover: role-derived adds, manual adds, then removals — so a group that moves from "role-derived" to "manually added" in one request is never briefly absent.
- A group in both `add_group_ids` and `drop_group_ids`: refuse at raise (the form shouldn't send it).
- If a manually added group is *also* granted by a role the person ends up holding, the role wins (role-derived); don't record an exception for it.
- `mover_notes`: "Manual group(s) added: …".
- `mover-preview` echoes the adds back resolved (name, description, privileged or not) so the form and the request page read the same thing.

**Frontend** — `access/RaiseRequestModal.tsx`
- The lookup: reuse `useDirectoryGroupSearch` and the option rendering the "Change access" form already has (~line 927, 1037) — same hook, same eligibility, so the two forms offer the same groups. Server-side search; debounce as that form does.
- Exclusions that depend on this form's state (already a member, granted by a role picked here, already added) are applied client-side on top.
- State: a list of added group ids on the mover form → `add_group_ids`. `complete` for a mover also true when non-empty.
- Pills and the box reuse COM-873's; no components declared inside render; the Popover/Combobox jsdom quirks apply.
- Request page (`RequestDetailPage.tsx`): manual additions under the same heading as manual removals.
- OpenAPI drift script.

## Done when

- [ ] Add a group → type → pick: the group appears as a green pill; Don't add removes it.
- [ ] The lookup never offers a group the person is in, one a chosen role grants, a dynamic group, or one Compass can't change.
- [ ] A move that adds one cloud group and one AD group, roles unchanged, is raised, approved and run on staging: the person is in both (or the AD one is a to-do where Compass doesn't manage it), and both show as approved on that request.
- [ ] A privileged group asks for the extra approval, as on "Change access".
- [ ] The approver's view lists the additions by name.
- [ ] A later move that changes a role does not remove the manually added group.