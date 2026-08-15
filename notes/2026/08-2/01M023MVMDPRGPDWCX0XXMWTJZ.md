---
id: 01M023MVMDPRGPDWCX0XXMWTJZ
created: 2026-08-15T07:02:13.389724Z
updated: 2026-08-15T07:17:51.393559Z
type: task
title: A validated dismissal earns nothing — give it its own counter
project: 01KX671DATY39VW6GWK3M2T3DN
number: 722
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: active
tech: null
---
The first playbook run in this estate succeeded on 2026-08-15 and recorded **no efficacy**. IN-1344: `playbook_run_requested` 06:44:19 → `playbook_run_validated` 06:45:06 (`node_present.present == False`, actual `false`) → resolved with a composed note. The playbook is still **0/0**.

**Cause.** `record_playbook_efficacy` (`playbooks.py:576-585`):

```python
executed_ops = {c.operation for c in ... ProposedChange.status == "executed"}
if not executed_ops:
    return
```

It returns immediately when no change was executed. The Karpenter playbook has `allowed_operations: []` by design — it changes nothing — so `executed_ops` is empty and no point is ever recorded. Run it a thousand times and it stays 0/0.

**This breaks the chain at its narrowest point.** The no-op class was chosen as the first autonomous candidate precisely because it carries no risk. Autonomy (ISE-714) is gated on *proven*, proven is gated on efficacy, and efficacy is unreachable for exactly that class. The gate can never open for the playbooks it was designed to open for first.

**Decision (Steve, 2026-08-15): a separate counter for dismissals.** A validated no-op run earns a point in its own column, not in `efficacy_successes`.

"Correctly dismissed 6 times" and "fixed it 6 times" are different claims. Conflating them would let a dismissal record vouch for a remediation playbook's competence to *change* things — and since autonomy reads this number to decide whether to act unattended, that conflation would be the most consequential kind of wrong.

**Scope**
- New counters alongside `efficacy_successes` / `efficacy_total` — a dismissal total and its successes, so the anti-rot logic works the same way on both. A dismissal that turns out wrong (the incident reopens, or a human reverses it) must be able to count against the playbook, exactly as `success=False` does today.
- `record_playbook_efficacy` earns a dismissal point when a run's **preconditions held and all validation passed with an empty operation set** — a *validated* no-op, never merely a resolve on a matching incident. The point is earned by the run, not by the incident's status changing.
- `compute_tier` and the ADR 0056 §7 auto-demotion both need to say which counter they read. A dismissal record should not make a remediation playbook look proven.
- ISE-714's autonomy gate reads the counter matching the playbook's own class. `playbooks.py:591` already anticipates "an autonomous one by a stricter reading of the same number" — make explicit which number.
- Backfill the one run that has already happened, or note that it is lost; with a single data point either is defensible, but say which.

Blocks ISE-714. Surfaced by ISE-715. The question was flagged in ISE-711 as one to decide and arrived instead as a silent default.