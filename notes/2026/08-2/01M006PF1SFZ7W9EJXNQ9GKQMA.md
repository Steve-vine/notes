---
id: 01M006PF1SFZ7W9EJXNQ9GKQMA
created: 2026-08-14T13:17:02.905866Z
updated: 2026-08-15T06:53:50.375611Z
type: task
title: The autonomy rung — eligible, proven and tier-bounded, matched at creation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 714
sprint: sevhjex
comments:
- id: 01M00G3KHAM1D5VF8E7PA1XE7Y
  author: Steve Vine
  at: 2026-08-14T16:01:30.666541Z
  text: |-
    BUILT 2026-08-14 — PR #663, migration 0137. (CI running at time of writing.)

    **Three gates as specified, plus a fourth the task did not list.** An unattended run cannot be published without an **escalation route** (ISE-713): "a human happens to read the timeline" is not a failure path when nobody is reading it. It surfaces in `autonomy_blockers` alongside the other three, so an engineer sees the whole shape of the gate rather than one refusal per attempt.

    Numbers, per the ADR: `efficacy_total >= 8` at `>= 0.9`. The test asserts the *relationships* rather than the constants — strictly above `compute_tier`'s rubber-stamp line AND above the desk's own anti-rot floor — so the reasoning survives a future tuning of either.

    **Which counter is read is not incidental.** A concluding playbook's `efficacy_*` is structurally zero (it executes no operation), so reading autonomy off it would let anything through; a remediating one never touches `conclusion_*` for the mirror reason. `autonomy_standing` picks by what the playbook actually does.

    **Match at creation** in `promotion.py`, at the moment an incident opens. One match dispatches; two do not. Once-only per incident **including across a reactivation** — a recurrence is the strongest evidence the conclusion was wrong, so it is the last moment to reach it again unattended. Rate-limited at 10/hour estate-wide: not a performance limit, a blast-radius one. Marked dispatched *before* the enqueue and in the same transaction, so a broker failure cannot produce two concurrent decisions about one estate.

    **Demotion answers the "decide whether autonomy's floor is higher" question: yes, much.** The desk's floor is where a playbook does more harm than good; autonomy's is where it *stopped being proven*, which is far earlier and has to be, because nobody is watching. And it steps ONE rung — back to `desk_executable`, not `advisory` — so the capability is withdrawn without discarding the standing already earned. Checked on every outcome, including a recurrence retracting a conclusion.

    **Abort** reuses ISE-712's guard rather than racing it: the scheduled half already refuses anything no longer `awaiting_validation`, so the abort is a fact in the database. Only a *waiting* run can be aborted — interrupting one mid-execution is how you get a half-applied change. The banner carries the one fact a responder cannot infer from anywhere else: whether a human started it.

    `run_playbook_autonomous` is a task type + the same agent re-registered, with one paragraph added that is about the reader, not the work.

    Bootstrapping remains exactly as the task says: nothing can be autonomous today, because nothing is proven. ISE-715 gives the first candidate something to earn it with.
- id: 01M00HQWJVE1PXCRCX5Z3N9ZN0
  author: Steve Vine
  at: 2026-08-14T16:30:03.867057Z
  text: |-
    MERGED 2026-08-14 — PR #663.

    Amendment to the note above: CI caught a real defect the local runs did not, and it is worth recording because it would have been invisible until the worst possible moment.

    **A new AI task type does not degrade without a config row — it FAILS.** `run_agent` raises `no model config for task type '…'` before it ever reaches the agent. So `run_playbook_autonomous` needed a *seeded* `ai_model_config` row (migration 0137 now recreates the task_type constraint and inserts it, the 0122 `draft-report-query` pattern), plus an `AI_TASK_DESCRIPTIONS` entry — without which the AI Models card 500s on every load.

    Both are total maps over the task-type list that a new entry must be added to by hand. The failure mode is the ISE-711 lesson again: a backend requirement breaks silent callers. And the specific shape of it here is worse than usual — every autonomous run would have failed at its first step, on the one path where **nobody is watching to notice**.

    Sonnet, matching `run_playbook`, and for the same reason it is not Haiku: the model executes nothing (the envelope makes the steps deterministic), but it decides whether reality matches the procedure at all. The allocation is now tunable in the app, which is the entire point of the separate type.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
The capstone of ADR 0101: a playbook may run without a human triggering it. Everything below depends on ISE-711/712/713 landing first.

**A third rung on `desk_state`.** Today: `advisory` → `desk_executable`, published by a second engineer, and editing retracts (`playbooks.py:256-293`). Autonomy is the next rung and inherits that posture — publish by a second engineer, **edit retracts autonomy**. The existing auto-demotion (4 outcomes below a 0.5 ratio) is the ready-made retraction on rot; decide whether autonomy's floor is higher than the desk's.

**Three gates, all required.** Autonomy is earned, never declared:
1. **Eligible** — the flag an engineer sets, meaning "may run unattended once proven". Never "trusted now".
2. **Proven** — efficacy history clears a bar above `compute_tier`'s current `rubber-stamp` line (`efficacy_total >= 2`, ratio `>= 0.66`). Two applications is far too thin to act unsupervised on; propose a real number in the ADR.
3. **Tier-bounded** — the envelope's operations sit within the autonomous ceiling. The desk ceiling is already T1/T2 with T3 never; autonomy should start lower, and the first release should arguably be T0 only — the no-op class from ISE-711, which changes nothing.

A new playbook can never run autonomously however it is flagged. That property is the point.

**Match at creation.** Today `match_playbooks` runs only on read — nothing compares an incident to the library until a human or an AI opens it, so a match cannot trigger anything. Autonomy needs the comparison at promotion, in `promotion.py`, which currently has no playbook reference at all. Consequences to handle: a single match with the gates met dispatches a run; multiple matches do not (ambiguity is a reason to wait for a human, not to pick one); and a burst of incidents must not stampede — rate-limit and make dispatch once-only per incident, including across a reactivation.

**Model assignment.** `ai_model_config` is keyed by `task_type`, so this is a new task type plus a config row, not new machinery. Put the strong model where judgement actually happens — deciding an ambiguous validation and composing the escalation — not on executing steps, which the envelope makes deterministic. A prescriptive run needs little model at all.

**Abort and visibility.** An autonomous run can be waiting for up to its `wait` window. An operator opening the incident mid-run must be able to see a run is in flight and stop it, or the human and the run will both act on the same incident.

**Bootstrapping is a real constraint, not a caveat.** 0 of 143 terminal incidents have an executed fix, so no playbook can be proven today. Manual playbook runs have to become routine before any of this can fire — which makes the no-op class (ISE-711) the sane first target: it earns efficacy through a path that carries no risk.

Depends on ISE-710, ISE-711, ISE-712, ISE-713.