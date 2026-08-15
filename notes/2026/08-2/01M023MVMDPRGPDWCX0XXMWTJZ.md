---
id: 01M023MVMDPRGPDWCX0XXMWTJZ
created: 2026-08-15T07:02:13.389724Z
updated: 2026-08-15T07:43:41.252133Z
type: task
title: A validated dismissal earns nothing — give it its own counter
project: 01KX671DATY39VW6GWK3M2T3DN
number: 722
sprint: sevhjex
comments:
- id: 01M0260S4WVBZ0EJN6AJXK64BX
  author: Steve Vine
  at: 2026-08-15T07:43:41.21242Z
  text: |-
    Done — PR #671, merged to main.

    **The counter already existed, and it worked.** ISE-711 added `conclusion_successes`/`conclusion_total` and the runner has been writing to them since. Checked the staging database directly: the Karpenter playbook reads **conclusion 1/1**, earned by the IN-1344 run on 2026-08-15. So the premise in the task body — that `record_playbook_efficacy`'s early return meant no point was ever recorded — was not what happened. Nothing needed backfilling; the point was there all along.

    **What was actually broken was everything downstream of the counter.** `is_advisory` was defined as "names no remediation option", which a concluding playbook satisfies, so it was treated as advisory by every surface that told the two apart:

    - The Playbooks page and the incident's Playbooks section both showed it the advisory badge — "advisory · not yet judged" over a real 1/1. **That is the 0/0 you saw.** Not a smaller version of the truth, the opposite of it.
    - Recall offered it a Helped / Didn't apply verdict, which records a `PlaybookFeedback` row that nothing ever reads for this class.
    - `compute_tier` and `maybe_demote_desk` read `efficacy_*` — structurally zero for the class. So a concluding playbook could never become proven however often it was right, **and never decay however often it was wrong**. That second half is the worse one: anti-rot that cannot see the record it is meant to be guarding.

    **Changes.** `is_advisory` now excludes the concluding class; `claim_class` names the three claims; one `proven_standing(playbook)` reads the counter matching a playbook's own claim and is shared by `compute_tier`, `maybe_demote_desk` and `autonomy_standing`, so the three gates cannot come to disagree about which number a playbook's standing lives in. A dismissal record still cannot prove a remediation playbook — there is a test that gives one 9/9 conclusions and asserts it stays unproven.

    **One scope item not done, deliberately.** "A dismissal that turns out wrong (the incident reopens, or a human reverses it) must count against the playbook." The reopen half is covered — recurrence refutes, via `promotion.py`. The human half **has no path in ISE**: `VALID_TRANSITIONS["resolved"] == {"closed"}`, and `reactivated` is written only by the recurrence code. An operator who reads an auto-resolution, disagrees with it and wants to reopen the incident simply cannot. I wrote the refutation branch, found it was unreachable, and took it back out rather than ship dead code implying a capability that does not exist. Raising it separately — it is an incident-lifecycle change, not a playbook-scoring one.

    Verified: ruff/mypy clean, 269 backend integration tests, full frontend suite (922 tests).
assignee: steve
label:
- bug
priority: high
task_status: review
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