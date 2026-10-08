---
id: 01M4BBACE4HCD4D0TS05X01NCM
created: 2026-10-07T14:12:15.94002Z
updated: 2026-10-08T15:45:25.353385Z
type: task
title: A membership of a dynamic group reads "Dynamic", not "Unexplained"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 854
sprint: sme8esk
comments:
- id: 01M4BBW48TP0JFGKX25V8HXFRE
  author: Steve Vine
  at: 2026-10-07T14:21:57.402425Z
  text: |-
    Checked 2026-10-07 (read-only) — where dynamic groups show up as "unexplained" today. This replaces the "verify each" list in the body.

    They do appear:
    1. A person's details ▸ Groups — the marker beside each dynamic group.
    2. A group's details ▸ Members (and nested groups) — on a dynamic group, every member is marked Unexplained.
    3. A mover request after it has run — the outcome line on the person: "N membership(s) Compass cannot explain, kept as unexplained: A, B, C…" names every one of them, dynamic groups included (`business_role_holdings.mover_notes` / `plan_mover`).
    4. Reports — the built-in "Unattributed memberships" report, and any report on memberships using the "why" column, list dynamic memberships as unexplained (`reports/catalogue.py`, `seed/reports.py`).
    5. Access coverage — the "nobody has explained yet" figure counts them (`membership_provenance.coverage`). On staging: 47,034 unexplained memberships, of which 18,828 (40%) are of dynamic groups — 55 groups, 1,557 people.

    They don't:
    - Coverage proposals already leave dynamic groups out (COM-737).
    - Recertification doesn't use the marker.
    - The mover and leaver forms' "unmanaged memberships are untouched" line doesn't say Unexplained (COM-855 splits the mover's).
    - The mover's "keep or drop?" question is not on any screen today — only the API takes it. Correction to the body: there is nothing to hide on the form. The API would accept a dynamic group in it, which then fails at the write; refuse it at raise instead.

    Cause: the directory sync writes an "unexplained" record for every membership it sees, with no regard to the group being dynamic.
- id: 01M4BHHQ48FZP8TYZV1581PKS2
  author: Steve Vine
  at: 2026-10-07T16:01:07.719916Z
  text: |-
    Done — PR #859, merged to main (778d3f2). Goes to staging with the other three.

    What people see now
    - A dynamic group's membership reads "Dynamic" — on a person's details, on a group's members and nested groups, and in the list the mover form reads. Hovering says the group's rule put them there and nobody can change it by hand. Role, Exception, and Unexplained on ordinary groups are unchanged.
    - Access coverage: the "nobody has explained yet" figure no longer counts dynamic memberships.
    - A mover's outcome no longer names dynamic groups under "memberships Compass cannot explain".
    - Reports: the Why column reads "The group's rule decides" for them, they count as explained, and the built-in Unattributed memberships report leaves them out.

    What to expect on staging
    - The unexplained figure will drop from 47,034 to about 28,206 in one step. That is the 18,828 dynamic memberships (55 groups, 1,557 people) leaving the count — nothing has been explained.

    Decisions I took (say if any is wrong)
    - "Dynamic" has its own colour (indigo), separate from Unexplained's grey.
    - It follows the group: nothing is stored as "dynamic", so a group switched to assigned goes back to reading as whatever its memberships are.
    - Asking a mover to drop a dynamic group is now refused when the request is raised (it was accepted and then failed at the write). That was only reachable through the API — no screen offers it.

    Unchanged, because they were already right
    - Coverage proposals already left dynamic groups out; recertification doesn't use the marker.

    Smoke test
    1. Open someone in a dynamic group (e.g. an all-staff group): the group reads Dynamic.
    2. Open that group: every member reads Dynamic.
    3. Access coverage: the unexplained figure has stepped down.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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