---
id: 01M008BMZYHBVZW2XQR27JT0YA
created: 2026-08-14T13:46:05.694005Z
updated: 2026-08-14T15:50:10.88173Z
type: task
title: Author the Karpenter node recycling playbook — the acceptance test for the whole chain
project: 01KX671DATY39VW6GWK3M2T3DN
number: 715
sprint: sevhjex
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
ISE-709 describes a playbook; no `Playbook` row exists. ISE-710..714 change the *format* — none of them create the *content*. This authors it, publishes it, and runs it, which makes it the acceptance test for everything above: if the Karpenter playbook cannot be expressed and run end to end, the envelope work is not finished.

**The playbook** (from ISE-709, in the ISE-711/712 shape):

- **kind** `node_not_ready`, unscoped — any node, not pinned to one entity.
- **precondition** (`source: estate`): the node carries a Karpenter marker. Verified present on the live estate — node `8b54f376` (`ip-172-21-119-61.ec2.internal`) holds `karpenter.sh/nodepool`, `karpenter.sh/nodeclaim`, `karpenter.sh/registered`, `karpenter.sh/capacity-type` and `karpenter_nodepool` as tags. Pick the most stable of them; `karpenter.sh/registered` and `karpenter.sh/nodepool` both look durable.
- **allowed_operations** `[]` with `outcome_on_pass: record_and_resolve` — changes nothing in the estate (needs ISE-711).
- **wait** anchored to `signal_first_seen`, 1800s (needs ISE-712).
- **validation** `node_present(name) == false`, with the name bound from `target_scope: affected_entity` (needs ISE-712's parameter binding).
- **escalation** route: raise a FreshService ticket, or message the assignee in Teams — the node is still there 30 minutes on, so it is a real node fault, not a recycle. Not urgent enough to wake anyone (ISE-713).

**Steps**
1. Author it in the playbook editor once the envelope fields exist.
2. Publish it desk-executable. A single-operator estate is fine — ISE-640 lets an admin self-publish, audited as `playbook_self_published_desk`.
3. Run it **manually** on the next `node_not_ready` incident and confirm each stage does what it should: precondition gates correctly on a non-Karpenter node, validation binds the right node name, the pass path writes a resolution note naming the playbook, the fail path escalates somewhere real.
4. Only then consider the autonomy rung (ISE-714) — it needs efficacy history this playbook does not have yet.

**Deliberately a real incident, not a fixture.** Every gap in this chain was found by trying to express a real playbook against real code; the last one — validation queries never receiving parameters — would have passed any unit test written against the current shape, because the shape itself was the bug.

Depends on ISE-711, ISE-712, ISE-713.