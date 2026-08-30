---
id: 01M19HGKBJB4ZNWAWE267SXQ87
created: 2026-08-30T14:34:56.754645Z
updated: 2026-08-30T16:56:24.392021Z
type: task
title: A mover says what they hold now and what they will hold — keeping a role is a choice
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 536
sprint: sz42uhw
comments:
- id: 01M19Q3C4ZR4MYK6F71WTMPNVR
  author: Steve Vine
  at: 2026-08-30T16:12:34.847761Z
  text: |-
    Done — PR #545, merged to main.

    **The staleness call, taken as recommended:** the approver's view re-reads the roles and marks any difference. The subject now snapshots `held_business_role_ids` at raise time (migration 0157) while `held_business_roles` stays the live read, and the output carries both. Where they differ the approver is shown it — "their roles have changed since this was raised — they hold Service Desk Analyst now" — *and* told what approving would do: a whole-set mover would undo that change too; a delta (COM-534) names only the one role it changes, so the rest is left alone. Not blocked on: the second person is exactly who should be allowed to look and decide.

    The form, now:

    - **Roles now** — what they hold, read-only, with a **Keep** on each row. On day one that is empty for everybody, which is the honest state rather than a missing panel.
    - **Roles after this change** — starts empty. Every role that survives the move is one somebody chose to carry over. Keeping four of five roles is four clicks rather than four searches, but it is still four acts.
    - Where roles are leaving they are **named before submit**: "this takes away 2 roles they hold now: Finance Manager, Service Desk Analyst". That is exactly the case that was silently wrong.
    - An **empty after-list is confirmed, never slipped through** — "this removes all 5 of their roles, and the managed groups those roles gave them".

    The approver sees the **change**, not two sets: "+ Payroll Clerk / − Finance Manager / kept Service Desk Analyst", with the lists underneath because the evidence of what was true at the time is the part an auditor comes back for.

    The form half needed a read that did not exist: `GET /directory/users/{id}/business-roles`, company-scoped because `set_held_roles` replaces the set for one company. It sits beside `/groups`, which answers the same shape of question about memberships. The request half was display, not plumbing — `held_business_roles` has been resolved per subject since COM-448 and the frontend had never rendered it.

    Leaves the mover's unexplained-membership question exactly as it is — a different list, about memberships rather than roles, and the two must not merge on screen.

    Verified: 2 new backend tests (the held-roles read, and the snapshot diverging from the live read), 6 new frontend tests in MoverRoles.test.tsx, 4 more in RequestsPage.test.tsx for the approver's diff and both readings of the drift. CI green across the board.

    **Worth a look:** Access Control → Requests → Raise → Mover. Pick somebody who holds a role and then pick one different role — the warning naming what is leaving is the thing that was missing.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: high
task_status: done
---
Executing a mover **replaces** the person's whole business-role set for that company. The form does not say so. It opens with one empty role picker and no sign of what they hold today, so picking a single role and submitting silently strips every other role that person had — and neither the requester nor the approver is shown what was there before.

Decided 2026-08-30: the mover states the before and the after, and keeping a role becomes a deliberate act rather than something that happens by not noticing.

## What changes for the reader

Two lists on the mover form.

**Roles now** — what this person holds, read-only. On day one that is empty for everybody, which is the honest state rather than a missing panel.

**Roles after this change** — starts empty. The requester builds the moved-to state, and every role that survives the move is one somebody chose to carry over.

Each row in *Roles now* has a **Keep** action that moves it across. Keeping four of five roles has to be four clicks, not four searches — but it is still four acts, and that is the point. A form that made carrying everything over the default would be the form we already have.

**Submitting an empty *after* list is allowed and confirmed, never slipped through.** Moving somebody to a job Compass does not model yet is a real case; doing it because the form was left alone is not. "This removes all 5 of their roles" before the request is raised.

## What the approver sees

Not the two lists — the **change**. "Finance Manager removed, Payroll Clerk added, Service Desk Analyst kept." A requester thinks in before-and-after; an approver is judging the difference, and handing them two sets to diff by eye is how a wrong one gets waved through.

The lists belong on the request too, under the diff, because the evidence of what was true at the time is the part an auditor comes back for.

## The staleness to settle

*Roles now* is a snapshot: read when the request is raised, shown to somebody approving it a week later. If the person's roles changed in between, the request describes a before-state that is no longer true, and approving it reverts that other change without saying so.

Recommend the approver's view **re-reads current roles and marks any difference** — "held when raised: Finance Manager, Payroll Clerk; held now: Finance Manager" — so the drift is visible at the moment of the decision. Blocking on it would be worse: the second person is exactly who should be allowed to look at it and decide.

This is the one part that is a design call rather than a build.

## Why this shape

It does not change what a mover means; it stops concealing it. Execution has always replaced the set, and this is that fact drawn on the screen. It is also the argument ADR 0061 §3 already makes about unexplained memberships — a job change is the moment to *ask*, not the moment to carry things over quietly.

## Notes

- **The before-state already exists on the API.** `held_business_roles` is resolved per subject on every request output (`api/v1/access_requests.py`, "what the mover is moving them away from" — COM-448). The frontend has never rendered it anywhere. So the request half of this is display, not plumbing.
- **The form half needs a read that does not exist.** There is no endpoint answering "what does this person hold?" outside a request, so the picker cannot show *Roles now* until there is one. Shared with COM-534, which needs the same read.
- `moverRoles` in `RaiseRequestModal.tsx` is the picker to replace — it opens `useState<string[]>([])` today, which is where the silent strip comes from.
- Company-scoped throughout: `set_held_roles` replaces the set *for one company*, and roles a person holds under another company are untouched and out of this screen.
- Leaves the mover's unexplained-membership question exactly as it is (COM-448) — that is a different list about memberships, not roles, and the two must not merge on screen.

## Verifying

Picking one role for somebody who holds three, and seeing the other two named as leaving before submit — the case that is silently wrong today. Keeping a role and seeing it survive. An empty after-list confirming rather than proceeding. The approver's diff naming added, removed and kept. And, if the re-read is taken: a mover raised, the person's roles changed elsewhere, and the approver shown that they differ.
