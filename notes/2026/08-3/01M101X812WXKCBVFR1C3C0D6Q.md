---
id: 01M101X812WXKCBVFR1C3C0D6Q
created: 2026-08-26T22:09:04.03419Z
updated: 2026-09-01T13:55:52.543857Z
type: task
title: 'ADR: roles decide, exceptions show — the access model, rewritten'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 446
sprint: snq23hz
comments:
- id: 01M12MYGXKV001X9KQ6ZG5RJ4D
  author: Steve Vine
  at: 2026-08-27T22:20:17.715128Z
  text: |-
    Done — merged to main as abd4cea (PR #462).

    `decisions/0061-roles-decide-exceptions-show.md`. Docs only; no code, no migration.

    **What it records.** The rule in one sentence — business roles decide who is in which group, everything else is an exception, visible as one and attributable to a person and a reason — then eight sections applying it: provenance on every membership, a person's roles as a fact, the sixth request kind, the Access Admin gate, two-lane detection, and the cold start.

    **Amends ADR 0045 §4, §5.3, §5.4, §6, §7, §9.** 0045 is left exactly as it was — append-only, supersede-never-rewrite — and 0061 carries the `Amends:` header, following what ADR 0042 did to 0039. Section 8 is the was/becomes table so the two read together.

    **The three calls the brief left open are in as decisions, not as prose:** the matrix stays closed to privileged groups permanently (privilege is always an exception with a name against it); approved exceptions survive a mover and get listed on it; no upfront mapping exercise. Each has its rejection reasoning in Alternatives, so a later task can't quietly re-litigate one.

    **The honest limit is recorded too** — "flag for reversal" has no ending Compass can execute for a directory role assigned straight to a person, because no such write exists. The item stays open until reality agrees, and 0061 says an item that closes itself while the privilege is still held is the worst outcome the feature could produce.

    Also written down for the tasks behind it: provenance is a prerequisite rather than a companion (exceptions built first would be deleted by the first mover to run), and the mover's existing tests are rewritten rather than patched because their premise is what §3 replaces.
assignee: steve
label:
- brief
priority: high
task_status: done
---
Docs only, and it gates the rest of the sprint. The model was agreed 2026-08-26 and written up as a design page; this turns it into the decision record, because six of the changes below reverse things ADR 0045 decided deliberately and none of them may be built on a conversation alone.

**The rule.** Business roles decide who is in which group. Everything else is an exception — visible as one, attributable to a person and a reason.

## What the ADR records

- **Membership carries provenance**: role-derived, an approved exception, or unattributed (true before Compass governed it). Unattributed stays firmly apart from exception — one was decided, the other inherited.
- **A person holds business roles on the record**, so a mover removes what the *previous* role granted rather than sweeping everything the new roles do not imply.
- **Exceptions, from either end** — from a group (members, including nested groups) or from a person (their groups). One request kind underneath.
- **Role-assignable groups become governable**, through the exception path only, gated by a new **Access Admin** application role. The matrix stays closed to them: a business role must never grant administrator rights as a side effect of a joiner.
- **Detection widens to every group**, in two lanes — needs-validation and for-information — and gains unprocessed leavers and directory-role changes.
- **The cold start**: unattributed is a legitimate launch state; the coverage tool is the migration, not a later enhancement.

## What it rewrites in ADR 0045

| | Was | Becomes |
|---|---|---|
| §4 | The matrix is the boundary of what Compass governs | The matrix defines role-derived membership; the governed set widens to anything Compass has written to |
| §5.3 | Role-assignable groups refused everywhere | Refused in the matrix; reachable as an exception with an Access Admin approving |
| §5.4 | Execution refuses to act on a privileged account | Acting on one needs Access Admin approval — refusal blocks the leaver you most need |
| §6 | Five request kinds, all role-derived | A sixth: an explicit membership change |
| §7 | Detection watches managed groups only | Watches everything, two lanes, new kinds |
| §9 | Three access roles | Four — Access Admin gates privilege |

Supersede, never rewrite (CLAUDE.md): ADR 0045 stays as accepted and this one records what changed.

## Decisions to carry across verbatim

Three calls were made where the brief was silent, and the ADR should state them as decisions rather than leave them to be re-litigated per task:

- **The matrix stays closed to privileged groups** — privilege is always an exception with a name against it.
- **Approved exceptions survive a mover** — an exception was deliberate and does not evaporate because someone changed job. The mover lists them; it does not remove them.
- **No upfront mapping exercise** — mapping 1,500 users before launch designs roles at the point of least knowledge. Unattributed-as-a-state plus the coverage tool reaches the same place with evidence.

Also record the honest limit: "flag for reversal" has no ending Compass can execute for a directory role assigned straight to a person. The item stays open until reality agrees.

## Not in scope

No code. Expect the ADR, plus the sprint's other tasks referencing it.