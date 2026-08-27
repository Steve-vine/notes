---
id: 01M101Z8QAR4M12ZBSFE4SGVV0
created: 2026-08-26T22:10:10.282385Z
updated: 2026-08-27T23:51:23.856405Z
type: task
title: Exceptions, opened from either end — from the group, or from the person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 450
sprint: snq23hz
comments:
- id: 01M12T5ABVMD28CCR6QGQXJDFG
  author: Steve Vine
  at: 2026-08-27T23:51:23.2597Z
  text: |-
    Done — merged to main as a6462ec (PR #466). Full CI green.

    **Two doors, one form.** From a group: "Add member…" above the users table, "Remove…" on each *direct* member, "Remove…" on each nested group — the membership list stops being read-only. From a person: "Change groups…" beside the Groups panel. From the Raise menu: `membership_change` joins `KIND_LABELS`, which the menu already iterates, so the requests screen got it for free.

    All of them open a pre-filled request with a `MembershipSeed`. **Nothing writes directly** — the one Graph write path stays the only path, and the form says what it is doing: *"Each becomes an approved exception, with your reason against it."* The reason gates Submit, because the server requires it in both orderings.

    **Provenance wherever membership is listed.** One resolver — `provenance_by_principal`, keyed by principal *or* by group — behind the member list, the nested list, the account modal and the mover form, so the four surfaces cannot disagree about the same membership. `DirectoryUserGroupOut` was folded onto the same shape COM-448 introduced flat, so a single badge component reads them all.

    The answer is on the badge, not behind a hover: "Role: Accounts Payable Clerk" reads at a glance, and a role name is what somebody actually needs. An exception links to the request that decided it — the next question is always *who asked for this*.

    **The unexplained marker.** Grey, not amber; "Unexplained", not "Unknown" or "Invalid"; and the explanation says what resolves it ("Recertification and the coverage tool explain these over time"). A warning colour would make the honest launch state look like 1,500 defects. There is a test asserting the wording does not read as a fault.

    **An inherited member carries no provenance at all.** The reason belongs to the nested group's own membership, and answering for the wrong edge would be worse than saying nothing — the same argument that makes `via_groups` exist. Removal is likewise offered on direct members only.

    Privileged groups: absent and saying why, which COM-451 then turns into a gate.

    One incidental fix: `UserDetailModal` reads the company through `useContext(CompanyContext)` rather than `useCompany()`. The modal is reachable from surfaces outside a `CompanyProvider`, and "no company chosen" is a real state — the affordance is simply absent, which beats a thrown error. An existing UsersPage test was rendering it exactly that way.

    10 new component tests plus 3 integration tests over the shared resolver.
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: review
---
Stacks on COM-449, which builds the request underneath. Part 4 of COM-446, the half people see.

Two doors, because people arrive at the problem from both directions — sometimes you are looking at a group and know who should be in it, sometimes you are looking at a person and know what they need.

## What changes for the reader

**From the group.** Open a group and add or remove its members — people or nested groups. The membership list stops being read-only.

**From the person.** Open someone's Account details and add or remove the groups they belong to.

Either way you say why, it goes for approval, and it appears in the request history like every other change. Same form underneath, two entry points.

## Scope

- **`access/GroupDetailModal.tsx`** — an add/remove affordance on the members list, and on the nested-groups list. Guarded by the same write permission as raising any other request.
- **`access/UserDetailModal.tsx`** — the same, against the person's groups.
- **The Raise request menu** gains the kind, for people who start from the requests screen rather than from a thing.

**Show provenance where membership is listed.** Once COM-447 lands, a membership is role-derived, an exception, or unattributed — and a reader who cannot see which cannot tell governed access from inherited access. Mark it on the member lists, and say which role or which request where there is one. This is the surface where the whole model becomes legible, so it is worth more than a tooltip.

**Privileged groups.** Until COM-451 lands, the affordance is absent or refused on role-assignable groups, and says why rather than failing silently.

## Tests

Component tests for both entry points, the permission guard, and the provenance markers rendering all three states. The unattributed marker is the one to get right — it is what 1,500 people will be on day one, and it must read as "nobody has said why yet", not as an error.