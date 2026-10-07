---
id: 01M4BBMTH9RC7PM9B0YPVN4EWF
created: 2026-10-07T14:17:58.057994Z
updated: 2026-10-07T14:18:00.816859Z
type: task
title: Mover form — the memberships that stay as they are are listed under two headings, Assigned and Dynamic
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 855
sprint: sme8esk
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Asked for by Steve after smoke-testing sprint 63 on staging, 2026-10-07: *"On the Mover request, the Membership diff shows which groups will be added and removed based on the role change and lists those groups that stay the same as they were assigned outside of the role. Can these be split into 2 groups, Assigned and Dynamic, with a title for each section."*

Goes with COM-854 (a dynamic group's membership reads "Dynamic", not "Unexplained") — both need the form to know which of a person's groups are dynamic.

## Why

Under the groups a move adds and removes, the mover form lists everything else the person is in as one run-on line: *"Unmanaged memberships are untouched: A, B, C, D…"*. Two different things are mixed together in it:

- groups somebody **put** the person in, outside any role — which a person could take them out of, and which may deserve a second look when they change jobs;
- **dynamic** groups, where a rule put them there — nobody can add or remove them, and the move may change them by itself if the rule looks at department or job title.

Read as one list, neither stands out.

## What people see

In the mover form's **Membership diff**, below the groups being added and removed, the memberships that stay as they are appear in two titled sections:

- **Assigned** — groups the person was added to outside their roles. Unchanged by this move.
- **Dynamic** — groups a rule puts them in. Unchanged by this move; the rule decides.

Each section lists its groups by name, and is left out when it has none. If the person has neither, nothing is shown, as now.

The added / removed part of the diff is unchanged.

## Decisions taken (say if any is wrong)

- **A list under each title, not a run-on sentence** — one group per pill or line, so a long set can be read.
- **The Dynamic section says the rule decides**, in a line under its title: a move that changes someone's department can change their dynamic groups without Compass doing anything, and that is worth saying where the mover is being raised. (After COM-849 a mover can change the very details those rules read.)
- **Only the mover form.** The leaver form's preview has the same one-line "Unmanaged memberships are untouched" — left as it is; say if it should be split the same way.
- **"Assigned" here means "not from a role and not dynamic"** — it includes approved exceptions as well as memberships nobody has explained. Each still carries its own marker (Exception / Unexplained) if you want that shown beside the name; the task assumes yes, since the marker is already there on the person's details.

## Notes (technical)

- Form: `MoverDiff` in `app/frontend/src/access/RaiseRequestModal.tsx` — the block under *"Membership diff (managed groups only)"*; the line to replace is *"Unmanaged memberships are untouched: …"* built from `currentGroups.filter((g) => !g.managed)`. (The leaver's `SubjectPicker` removal preview has the same line ~l.639 — out of scope here.)
- Data: `useDirectoryUserGroups` → `GET /directory/users/{id}/groups` → `DirectoryUserGroupOut` (`api/v1/schemas.py`): `id, display_name, description, is_assignable_to_role, managed, provenance`. It does **not** say whether the group is dynamic. Add the group's `membership_type` (from `DirectoryGroup.membership_type`, `models/directory_mirror.py`) to that payload — or, if COM-854 lands first and returns `provenance: 'dynamic'`, read it from there. Either way one source, shared with COM-854; don't infer "dynamic" twice.
- Check what the endpoint lists today: its docstring says "security-group memberships". Confirm dynamic groups (and dynamic Microsoft 365 groups) are in it — if a kind is filtered out, the Dynamic section would be silently short.
- Reuse `MembershipProvenanceBadge` for the marker beside each assigned group.
- API change → regenerate `schema.d.ts`, run the drift script.
- Tests: `MoverRoles.test.tsx` — both sections with their titles; each omitted when empty; neither when the person has only role-managed groups; the added/removed diff untouched.

## Done when

- A mover for someone with assigned and dynamic memberships outside their roles shows them under "Assigned" and "Dynamic", each titled, each listing its groups.
- A section with nothing in it isn't shown.
- The groups added and removed by the role change read as before.