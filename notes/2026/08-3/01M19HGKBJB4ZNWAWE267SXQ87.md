---
id: 01M19HGKBJB4ZNWAWE267SXQ87
created: 2026-08-30T14:34:56.754645Z
updated: 2026-08-30T14:48:43.7058Z
type: task
title: A mover says what they hold now and what they will hold — keeping a role is a choice
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 536
sprint: sz42uhw
assignee: steve
company:
- moneypenny
label:
- improvement
priority: high
task_status: todo
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
