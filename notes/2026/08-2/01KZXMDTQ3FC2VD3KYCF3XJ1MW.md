---
id: 01KZXMDTQ3FC2VD3KYCF3XJ1MW
created: 2026-08-13T13:19:16.707737Z
updated: 2026-08-14T08:49:17.145434Z
type: task
title: '"Didn''t apply" votes on a playbook but never dismisses it — the Recall card comes back forever'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 688
sprint: sevhjex
comments:
- id: 01KZY2AY0XMJ5RWK8VT7737FV4
  author: Steve Vine
  at: 2026-08-13T17:22:21.853867Z
  text: |-
    2026-08-13 — DONE, PR #639 merged to main (migration **0132**).

    **The primitive.** `issue_suggestion_dismissal` — `(issue_id, kind, target_id, created_by, reason)` — one table for both kinds as the task directed, not two near-identical ones. This task owned the migration; ISE-689 stacks on it. `target_id` is deliberately NOT a foreign key: it points at `playbook.id` or `issue.id` depending on `kind`, which Postgres cannot express, and a dismissal outliving its target is harmless — it simply never matches again.

    **"Didn't apply" writes BOTH records**, as asked. One click, both meanings. They stay strictly apart: `PlaybookFeedback` is the playbook's standing across the estate (ISE-303), the dismissal is local to this incident. Conflating them would have been the ISE-630 mistake again, one row serving two questions.

    **Every row can be put away.** The dismiss used to ride on `is_advisory && canVote`, so a remediation playbook — scored by executed fixes, taking no feedback at all — had no dismissal and would have kept the card alive by itself. It gets a plain **"Not this one"**. Feedback stays advisory-only; dismissal is universal.

    **Reversibility — decided, not omitted.** Dismissed suggestions are SERVED by the API rather than merely filtered, behind "N put away on this incident — show", each with a **Restore**. I chose this over an undoable toast: a toast's undo lasts seconds, and the failure mode being guarded against ("a card quietly stops working and nobody knows why") appears weeks later. Restore deletes the row, so a restored suggestion is indistinguishable from one never dismissed — which is what the operator means — and the history lives in the audit trail, where `suggestion_dismissed` / `suggestion_restored` are recorded on the incident with the actor and the reason.

    **The card's emptiness rule is priors OR undismissed playbooks**, exactly as specified. On a first-time incident (`prior_count === 0`, the "ISE has a playbook for this" title Steve reported against) dismissing them all does empty it; with priors it survives, because that half is history and has nothing to do with playbooks.

    **Two things the task did not name, both decided deliberately:**

    1. **Tiering follows what is still standing**, not what matched. `compute_tier` gets the undismissed list — rubber-stamping an incident on the strength of a playbook the operator has just ruled out would be the worst possible reading of the dismissal.
    2. **The no-match explainer keys off what MATCHED**, not what survived. "No playbook matched this incident" and "you put the matches away" are different facts, and the explainer (ISE-634) answers only the first. Asserted in the tests.

    **One CI catch worth recording:** the migration's `created_at`/`updated_at` were nullable — a bare `server_default` does not imply NOT NULL — while `TimestampMixin` declares them NOT NULL. 3425 tests passed and only `test_migrate_zero_to_head_and_models_match` caught it. That check is the only thing standing between a migration and the model it claims to describe; it earned its keep here.

    6 backend integration tests (real Postgres) + 4 frontend, all green.
assignee: steve
label:
- improvement
priority: medium
task_status: done
tech: null
---
On the incident screen, clicking **Didn't apply** on every playbook in the "ISE has a playbook for this" card leaves the card exactly as it was. It returns on every visit.

**Cause — one button answering the wrong question.** `Didn't apply` (`IssueDetailPage.tsx:1412`) POSTs `/playbooks/{id}/feedback` with `helped: false`, which records *advisory standing* — a global judgement on the playbook's quality (ISE-303). It says nothing about **this** incident, and Recall re-matches by signature on every render, so the row reappears. The operator means "not relevant here"; the button hears "this playbook is bad everywhere". Same shape as ISE-630 — one name serving two questions.

**Wanted:** dismissing every playbook removes the card from this incident permanently.

**Scope**
- Per-incident, persisted dismissal of a playbook suggestion. See ISE-689 — both cards need the same primitive, and one `issue_suggestion_dismissal` table (issue_id, kind, target_id, actor, at) should serve both rather than two near-identical tables. Whichever task is built first owns the migration; the other stacks on it.
- `Didn't apply` does BOTH: keeps recording the advisory verdict (it is genuine quality signal) and dismisses the row here. One click, both meanings — that is what the operator intends, and splitting it into two buttons would be worse.
- **Every row needs a dismiss, not just advisory ones.** Today the button renders only for `pb.is_advisory && canVote` (line 1396), so a remediation playbook has no dismissal at all and would keep the card alive on its own. Dismissal is available on every row; *feedback* stays advisory-only.
- Recall filters dismissed playbooks out of its response, so the card's existing `playbooks.length` logic hides them without further change.

**Do not hide the whole card unconditionally.** It is dual-purpose: with `prior_count > 0` it is titled "Seen N times before" and carries prior history, which has nothing to do with playbooks. The rule is: render when there are priors OR undismissed playbooks; when both are empty, fall through to the existing "No prior history" line. The title Steve reported against — "ISE has a playbook for this" — only appears when `prior_count === 0`, so in that case dismissing them all does empty the card, exactly as asked.

**Reversibility.** A dismissal is durable and invisible once made, which is how a card quietly stops working and nobody knows why. Either surface dismissed suggestions behind a "show dismissed" affordance, or make the toast undoable. Decide explicitly rather than by omission.