---
id: 01KYJRHYY3C265P651X96G6HZR
created: 2026-07-27T21:44:05.827224Z
updated: 2026-07-27T21:53:58.61696Z
type: task
title: 'Playbook V2 model: envelope, lifecycle, second-engineer publish gate (+ authoring UI)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 343
sprint: sf23rna
assignee: steve
label:
- feature
priority: high
task_status: active
---
The data model that makes prose safely executable (migration from 0066 — check the chain, stacking rule applies).

- **Body**: freeform natural-language `body` (markdown) joins/absorbs the V1 lists — hypotheses/plan/options remain readable but the prose is what the interpreter follows. Existing playbooks keep working as advisory (V1 semantics untouched).
- **Envelope** (structured columns/JSONB, validated at publish): `allowed_operations` (explicit catalogue subset; publish REFUSES any T3 op — server rule, not UI), `target_scope` (how the run binds targets from the incident: affected entity / its namespace / entity-type constraint), `run_bounds` (max_actions, wall_clock_seconds, token_budget), `validation` (list of {evidence_query, field, operator, literal} predicates — checked against the query's declared payload shape at publish time), `escalation` (prose the interpreter follows on any bound/validation failure: stop + summarise, never improvise).
- **Lifecycle**: draft → advisory (today's behaviour) → **desk_executable**. Publishing to desk_executable requires an engineer who is NOT the sole author (separation of duties at publish, ADR 0056); publish/retract audited. **Anti-rot demotion**: efficacy ratio below a threshold auto-retracts desk status (audited, surfaced to engineers) until re-published.
- **Authoring UI** (extends ISE-302's editor): body editor, envelope builder with the catalogue picker and predicate builder, publish flow showing exactly what the desk will be able to do ("worst case: these ops on these targets"), second-engineer confirmation.

DoD: an engineer can author and (with a second engineer) publish a desk-executable playbook; a solo author cannot; a T3 op cannot enter an envelope; retract + demotion work.