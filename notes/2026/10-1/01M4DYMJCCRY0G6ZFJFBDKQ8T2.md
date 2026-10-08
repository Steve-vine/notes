---
id: 01M4DYMJCCRY0G6ZFJFBDKQ8T2
created: 2026-10-08T14:28:21.516782Z
updated: 2026-10-08T14:31:52.246565Z
type: task
title: The move form can remove a person's manual groups — sections renamed, click a group to see it and Remove or Restore
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 873
sprint: sme8esk
blocked_by:
- 01M4DWZRQS9T0JXAGJHRP0FXYB
comments:
- id: 01M4DYV05PRCR6VYBX6H7YA5V4
  author: Steve Vine
  at: 2026-10-08T14:31:52.246417Z
  text: |-
    Correction, 2026-10-08 — "Some groups can't be removed here … a group Compass isn't allowed to change" overstates it. Checked against the code (DirectoryGroup.governable, _writable_or_refuse, _writable_group_ids):

    - The ONLY groups Compass will not change are dynamic ones, and those are already in their own section and not clickable. Security groups, Microsoft 365 groups, distribution lists and mail-enabled security groups are all changeable.
    - So every pill in Manual groups gets a Remove button. There is no "can't be removed" state to build, beyond a group that has gone from the directory since the form opened.
    - The one special case is a group that grants an Entra admin role (is_assignable_to_role). It CAN be removed, but the request then needs an Access Admin's approval — at run time _writable_group_ids refuses it otherwise, for removals as well as adds. The box should say so when Remove is clicked on one ("Removing this needs an Access Admin's approval"), and the request must route to that approval exactly as a "Change access" request naming the same group does.
    - Unchanged: an AD group Compass doesn't manage becomes a to-do.

    Done-when item "A group Compass may not change shows the reason and no Remove" becomes: "Removing a group that grants an admin role says it needs an Access Admin's approval, and the request is routed to one."
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve testing access control on staging, 2026-10-08: "I'd like the ability to make manual group changes on this page." This task is the layout and **removing**; adding a group is the next task.

**Blocked by COM-871** (the form's group lists come from the server's answer, and say correctly which groups a move removes).

## What people see

The groups part of a move request, top to bottom:

1. **Membership diff (managed groups)** — renamed from "Membership diff (managed groups only)". What the role change adds and removes (COM-871). Unchanged otherwise.
2. **Membership diff (manual groups)** — new. Same pills as the section above: red "− group" for each manual group this request will remove. Empty to start with ("No manual-group changes.").
3. **Manual groups (n)** — renamed from "Assigned (n)". Every group the person is in directly — not through one of their roles, not by a dynamic rule.
4. **Dynamic groups (n)** — renamed from "Dynamic (n)". Unchanged; not clickable, because a rule decides who is in them.

In **Manual groups**:
- **Pills show the group name only.** The "Unexplained" pill beside each goes.
- **Click a pill** → a small box with the group's **description**, one line saying **why they have it**, and a **Remove** button.
- **Remove** moves the group up into Membership diff (manual groups) as a red "− group", and the Manual groups count drops by one.

In **Membership diff (manual groups)**:
- **Click a red pill** → the same box, with **Restore**. Restore puts it back in Manual groups.

Raising the request carries the removals; the approver sees them listed on the request; when it runs, the person comes out of those groups.

A move that only removes a manual group — no role change, no detail change — can be raised.

### Two things that differ from what Steve said

- **"Every group here will always be Unexplained" isn't quite so.** A group somebody was given through a Compass request ("Change access") is recorded as an *approved exception*, and shows that pill today. So the pill goes, as asked, but the box says which it is — "Nobody has explained why they have this" or "Approved on request N" — because that is exactly what someone deciding whether to remove it wants to know.
- **Some groups can't be removed here**, and the box says why instead of offering Remove: a group Compass isn't allowed to change (the same ones "Change access" refuses). A group in Active Directory that Compass doesn't manage *can* be removed — it becomes a to-do for a person, as everywhere else.

## Decision record

ADR 0061 §3–4 says a move changes only role-derived memberships, keeps approved exceptions, and that "Change access" is the only kind of request that isn't role-derived. This task and the next let a move carry deliberate, named, manual group changes. Write a short ADR superseding that part — do not edit 0061. The principle it protects still holds: nothing manual changes as a *by-product* of a move; only what the requester picked by name and an approver saw.

## How (implementation)

**Backend**
- A mover subject already carries `drop_group_ids` (COM-448) and `plan_mover` (`core/business_role_holdings.py:196`) honours it — but only for memberships recorded **unattributed**. Extend it to any membership the person holds directly:
  - **approved exception** — today always kept; a named removal ends it;
  - **no provenance record at all** — `plan_mover` builds `records` from `GovernedMembership` rows, so a group with no row is silently ignored. Check whether groups no role grants have rows; if not, a named drop must still remove.
  - still refused: dynamic groups (already validated, `api/v1/access_requests.py:672`), and role-derived memberships of a role being kept (that is a role change, not a manual one).
- Validation at raise: reuse what `membership_change` refuses for a leave (governable groups, privileged gate) so the form and API agree. Re-check at run that the membership is still held directly, as the existing docstring describes.
- The run: removal goes through `_revoke_or_step` as now (on-premises → AD write or to-do). Ledger and notes: `mover_notes` says "Unexplained membership(s) dropped" — reword to cover exceptions ("Manual group(s) removed: …").
- `GET /access-requests/mover-preview` (widened by COM-871) returns, per manual group: id, name, description, why held (provenance + the request that approved it), removable or the reason not. The form should not need a second fetch per pill.
- A mover with unchanged roles, no details, and ≥1 drop is valid (see the no-op rule in the Account-details task).

**Frontend** — `access/RaiseRequestModal.tsx` (`MoverDiff`), `access/MoverStayingGroups.tsx`
- Titles and the new section as above. `MoverStayingGroups` filters on `!group.managed` today; after COM-871 "manual" means *not role-derived for this person and not dynamic*, whether or not some role maps the group.
- Remove `MembershipProvenanceBadge` from these pills.
- The box: a Mantine `Popover` on the pill (pill becomes a button — keyboard reachable, `aria-expanded`); one open at a time; Escape closes. jsdom hides a floating dropdown when its target re-renders — keep the popover's target stable across the move between sections, and no components declared inside render.
- State: a set of dropped group ids on the mover form, sent as `drop_group_ids`. Restore removes from the set.
- `complete` for a mover: also true when the set is non-empty.
- Request page (`RequestDetailPage.tsx`): list manual removals under their own heading, apart from role-derived ones.
- Screen conventions test: a pill never truncates; long group names wrap.
- OpenAPI drift script.

## Done when

- [ ] The four headings read as above; no "Unexplained" pills in Manual groups.
- [ ] Clicking a manual group shows its description, why it's held, and Remove; Remove moves it to the diff section in red; clicking it there offers Restore, which puts it back.
- [ ] A move that removes one unexplained group and one approved exception, with roles unchanged, is raised, approved, and both memberships are gone on staging; nothing else changed.
- [ ] A group Compass may not change shows the reason and no Remove.
- [ ] An AD group Compass doesn't manage becomes a to-do, not a failure.
- [ ] The approver's view lists the manual removals by name.
- [ ] ADR accepted.