---
id: 01M4BBACE4HCD4D0TS05X01NCM
created: 2026-10-07T14:12:15.94002Z
updated: 2026-10-07T14:12:19.940577Z
type: task
title: A membership of a dynamic group reads "Dynamic", not "Unexplained"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 854
sprint: sme8esk
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Asked for by Steve after smoke-testing sprint 63 on staging, 2026-10-07: *"In the user details modal (and probably elsewhere) groups that weren't added as part of business roles have 'Unexplained' next to them. This includes dynamic groups. Dynamic groups should just say 'Dynamic' rather than Unexplained."*

## Why

Every membership carries a marker saying why it exists: **Role: …**, **Exception**, or **Unexplained** — "nobody has said why yet". A dynamic group's members are put there by the group's rule. That is not unexplained: the rule is the explanation, and nobody can grant, approve or remove it by hand. Calling it Unexplained makes rule-driven membership look like a backlog somebody should be clearing.

## What people see

- Wherever a membership shows its marker, a membership of a **dynamic group** reads **Dynamic** — not Unexplained. Hovering says why: the group's rule put them there; change the rule (or the person's attributes) to change it.
- That is every place the marker appears today:
  - a person's details — their Groups list;
  - a group's details — its members and its nested groups;
  - the mover form's list of what the person has.
- **Role: …** and **Exception** are unchanged. A membership of an ordinary (assigned) group that nobody has explained still reads **Unexplained**.

### And the places that count or ask about "unexplained"

A label alone would leave Compass disagreeing with itself — "Dynamic" on the person, but still counted as unexplained elsewhere. So, wherever these turn out to include dynamic groups today:

- **The explained / unexplained figures** (coverage) leave dynamic memberships out of "unexplained": they are not a backlog anyone can work through.
- **A mover's "memberships Compass cannot explain — keep or drop?" question** does not list dynamic groups: there is nothing to keep or drop, the rule decides.
- **Coverage proposals and recertification** do not offer a dynamic membership as something to explain or remove.

## Decisions taken (say if any is wrong)

- **"Dynamic" is its own marker, in its own colour** — not a kind of Unexplained and not a kind of Role. Neutral, like Unexplained is, since nothing is wrong.
- **It is decided by the group, not stored on the membership.** If a group is switched from dynamic to assigned, its memberships go back to reading as whatever they are (usually Unexplained) by themselves, and the other way round.
- **A role that maps a dynamic group** is already refused (dynamic groups are browse-only), so "Role: …" and "Dynamic" never compete.
- **The second half (counts, the mover question, proposals, recert) is in this task** so the screens can't disagree. If you want only the label for now, say so and that half becomes a follow-on.

## Notes (technical)

- The marker is one component: `app/frontend/src/access/MembershipProvenanceBadge.tsx` (`LABELS` / `COLOURS` / `EXPLANATIONS`, keyed by `role_derived | exception | unattributed`). Used in `UserDetailModal.tsx` (~277) and `GroupDetailModal.tsx` (~86, ~147); check the mover form's membership list in `RaiseRequestModal.tsx` too.
- The answer comes from one resolver: `provenance_by_principal` in `app/backend/src/compass_api/api/v1/directory.py` (~165) → `MembershipProvenanceOut`. A membership with no record reads `unattributed`. Nothing in `core/membership_provenance.py` knows a group is dynamic.
- A group's kind is on the mirror: `DirectoryGroup.membership_type` (`DirectoryMembershipType.dynamic`, from `membership_rule` — `models/directory_mirror.py`).
- Recommended: add a fourth value to what the API returns — `dynamic` — resolved **on read** from the group's `membership_type`, taking precedence over a stored `unattributed` record. Don't add it to the stored `MembershipProvenance` enum (that is a Postgres enum; and "decided by the group" means it must not go stale when a group's type changes). For the group-keyed call the group is known once; for the principal-keyed call, look up the types of the groups in the result.
- The frontend type `MembershipProvenance` (generated) gains the value; the badge's three maps gain a key. Regenerate `schema.d.ts`, run the drift script.
- Counts and questions — verify each before changing, and say in the PR which ones did include dynamic groups:
  - `membership_provenance.coverage` (~498, "(explained, unattributed) for one company") and the coverage snapshot (`models/membership_coverage_snapshot.py`) — exclude dynamic groups from `unattributed`; check whether the snapshot history needs a note where the figure steps down.
  - `business_role_holdings.plan_mover` — the `unattributed` list a mover asks about, and `drop_group_ids` validation (`_validate_dropped_groups` in `api/v1/access_requests.py`): a dynamic group must not be offered or accepted.
  - Coverage proposals (`models/coverage_proposal.py`) and recert item generation — a dynamic membership is not a candidate.
  - Reports that carry provenance (`reports/catalogue.py`, `seed/reports.py`) — the column should read Dynamic too.
- Whether provenance records exist for dynamic-group memberships at all (the sync's reconcile writes `unattributed` rows for mirrored memberships) decides how much of the second half is real — check on staging with a read-only count before designing it.

## Done when

- On a person's details, a group's details and the mover form, a dynamic group's membership reads "Dynamic" with its explanation; assigned groups are unchanged.
- The unexplained figure, the mover's keep-or-drop question, coverage proposals and recertification do not treat dynamic memberships as unexplained — or the PR says, for each, that they never did.
- Switching a group's type changes how its memberships read without anything being rewritten.
- Tests: the resolver for a dynamic group (with and without a stored record) from both ends; the badge; each count/question that changed.