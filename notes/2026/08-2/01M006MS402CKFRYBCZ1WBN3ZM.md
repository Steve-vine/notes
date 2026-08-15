---
id: 01M006MS402CKFRYBCZ1WBN3ZM
created: 2026-08-14T13:16:07.680442Z
updated: 2026-08-15T06:53:36.08286Z
type: task
title: The envelope gains a precondition, and may change nothing at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 711
sprint: sevhjex
comments:
- id: 01M00DBR7F2PCQP9PCH012D85C
  author: Steve Vine
  at: 2026-08-14T15:13:31.887174Z
  text: |-
    DONE 2026-08-14 — PR #660, merged to main. Migration 0136.

    **The precondition.** `ValidationPredicate` gains `source: evidence | estate`, and the envelope gains a `precondition` list. Evaluated **before the interpreter**, not after — a playbook that does not apply should cost no tokens to discover that. A failed one raises a new `PlaybookNotApplicable` (a subclass of `PlaybookRunRefused`, so ISE-714 can catch *not applicable* specifically without swallowing real refusals) and names which precondition failed. The desk's Run endpoint answers it at the click; the Celery task returns `not_applicable` rather than dying into the failure queue.

    Estate facts are a **closed list** (`tag_keys`, `tags`, `entity.type|name|retired`, `entity.attributes.*`) validated at publish. Not gold-plating: an unknown dot-path reads `None`, and a `!=` predicate against `None` silently PASSES — the quiet wrong answer publish-time validation exists for.

    One thing decided while building that was not in the task: **a validation check may NOT read the estate.** The estate is what the last sync saw; success is a claim about now. Permitting it would close incidents on stale facts.

    **The empty operation list.** Permitted, paired with `outcome_on_pass`. The allowlist and `max_actions` must agree in **both** directions — "operations listed, budget 0" is as incoherent as its mirror, and the run would silently follow the budget. `record_and_resolve` goes through `apply_status_change`, never by setting the column: the transition rules, signal cascade, breakglass teardown and notification all hang off that function.

    **How the concluding class earns a score.** `conclusion_successes`/`conclusion_total`, separate from `efficacy_*`. Also added, and worth more than the counter itself: **a recurrence retracts the success.** Every run of a concluding playbook agrees with itself at the time, so its own runs cannot be the only evidence it is rotting — the signal coming back is. Hooked into the reactivation branch in `promotion.py`; the evidence pointer now carries `playbook_id` so the reactivation can find the row (a name is for reading, not for joining).

    `ranking_ratio` checks concluding FIRST, because such a playbook looks advisory from the V1 lists — it names no remediation option, having none — while being a published, runnable procedure. Ranking it on feedback nobody gives would strand it at the neutral prior forever, which is exactly what ISE-303 fixed for the advisory case.

    UI: the predicate table is now one `PredicateEditor` used twice; emptying the operations flips the form to the concluding shape (budget forced to 0, outcome forced and disabled) with an alert saying what it now is, rather than leaving an empty list that reads as an unfinished envelope. A "Concludes only · 5/6 held" badge on the desk row.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
Two envelope changes, both needed before the Karpenter playbook (ISE-709) can be expressed at all. `playbook_envelope.py`, ADR 0101.

**1. A precondition list — the applicability gate.**

Matching is `kind` + `entity` (`playbooks.py:157`). "Only for Karpenter-managed nodes" has nowhere to live but prose inside `investigation_plan`, so an autonomous run would fire this playbook on a bare-metal node in a cluster with no Karpenter and confidently conclude "expected".

- Reuse `ValidationPredicate` — same field/operator/literal shape, evaluated by the runner, not the model.
- Preconditions need **two sources**, unlike validation which only needs live evidence: estate facts (the node's tags say Karpenter-managed) and evidence payloads. Add a `source: estate | evidence` discriminator.
- Evaluated **before** any action. All must hold; a failed precondition is "not applicable", which is a clean no-op, not an escalation — the playbook simply did not apply.
- Validated at publish time like the rest of the envelope, so applicability is enumerable before a run can happen.

**2. `allowed_operations` must be allowed to be empty.**

Today it is `Field(min_length=1, max_length=10)`. The Karpenter playbook's remediation is *"update the incident with analysis and resolve it"* — it changes nothing in the estate. The envelope cannot currently express a playbook whose action is to conclude that nothing is wrong.

That class matters out of proportion to its size: it carries **no risk at all** (no `ProposedChange`, no tier, no rollback), which makes it the right first candidate for autonomy — and it is the shape most of ISE's real incidents take, given 0 of 143 terminal incidents had an executed fix.

- Permit an empty operation list, paired with an explicit `outcome_on_pass: record_and_resolve` so "does nothing" is stated rather than inferred from an absence.
- `run_bounds.max_actions` must then accept 0.
- The resolution note it writes should name the playbook and the validated predicate, so ISE-704's display work has something worth showing.
- **Decide how efficacy counts it.** "Correctly dismissed" and "successfully fixed" are both successes and are not the same claim; `compute_tier` cannot currently tell them apart, and autonomy is gated on that number.

Publish-time validation and the authoring UI both need to carry the new fields. Depends on ISE-710 for the decision; ISE-712 covers the validation half.