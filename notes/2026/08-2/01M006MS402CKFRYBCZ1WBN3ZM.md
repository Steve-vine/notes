---
id: 01M006MS402CKFRYBCZ1WBN3ZM
created: 2026-08-14T13:16:07.680442Z
updated: 2026-08-14T13:27:10.109874Z
type: task
title: The envelope gains a precondition, and may change nothing at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 711
sprint: sevhjex
assignee: steve
label:
- feature
priority: high
task_status: todo
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