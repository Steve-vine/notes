---
id: 01M006PF1SFZ7W9EJXNQ9GKQMA
created: 2026-08-14T13:17:02.905866Z
updated: 2026-08-14T15:31:37.484524Z
type: task
title: The autonomy rung — eligible, proven and tier-bounded, matched at creation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 714
sprint: sevhjex
assignee: steve
label:
- feature
priority: medium
task_status: active
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