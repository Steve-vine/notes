---
id: 01KYJRHYY3C265P651X96G6HZR
created: 2026-07-27T21:44:05.827224Z
updated: 2026-08-07T12:15:41.723765Z
type: task
title: 'Playbook V2 model: envelope, lifecycle, second-engineer publish gate (+ authoring UI)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 343
order: -1.0
sprint: sf23rna
comments:
- id: 01KYJSJCZ1FAK7RXXSKFTM2JHV
  author: Steve Vine
  at: 2026-07-27T22:01:48.769869Z
  text: 'Built (PR #317, branch feature/ise-343-playbook-model, migration 0066). Playbook gains body (interpreted prose), envelope (JSONB), desk_state + published_by/at. New playbook_envelope module owns publish validation: ops resolved against the union of connector action catalogues with T3 refused by name; predicates must reference statically-declarable evidence queries; ≥1 predicate mandatory ("success must be measurable, not the AI''s opinion"); bounds range-checked; plain_summary() renders the desk-facing "may run X on Y; checks Z" line. Lifecycle in playbooks.py: publish_desk enforces the second-engineer rule (author refused with the SoD wording), retract_desk is instant + audited, maybe_demote_desk auto-retracts at ≥4 outcomes with ratio <0.5 (wired into record_playbook_efficacy). PATCH endpoint retracts a live playbook on any edit — the desk only ever runs exactly what was approved. Authoring UI: PlaybookDeskSection with the envelope builder (ops, scope, bounds, predicate rows, escalation) and publish/retract; publish disabled for the author with the tooltip explaining why. 15 tests green (envelope unit + lifecycle integration + migration parity); full mypy/ruff/frontend gates green. One deliberate deviation from the task body: predicate FIELDS are validated for shape but not against a per-query payload schema — evidence payloads aren''t schema-declared today; the query NAME is validated instead, and the runner (ISE-346) treats a missing field at evaluation time as a failed check, which escalates. Noted for the acceptance walkthrough.'
assignee: steve
label: null
priority: high
task_status: done
---
The data model that makes prose safely executable (migration from 0066 — check the chain, stacking rule applies).

- **Body**: freeform natural-language `body` (markdown) joins/absorbs the V1 lists — hypotheses/plan/options remain readable but the prose is what the interpreter follows. Existing playbooks keep working as advisory (V1 semantics untouched).
- **Envelope** (structured columns/JSONB, validated at publish): `allowed_operations` (explicit catalogue subset; publish REFUSES any T3 op — server rule, not UI), `target_scope` (how the run binds targets from the incident: affected entity / its namespace / entity-type constraint), `run_bounds` (max_actions, wall_clock_seconds, token_budget), `validation` (list of {evidence_query, field, operator, literal} predicates — checked against the query's declared payload shape at publish time), `escalation` (prose the interpreter follows on any bound/validation failure: stop + summarise, never improvise).
- **Lifecycle**: draft → advisory (today's behaviour) → **desk_executable**. Publishing to desk_executable requires an engineer who is NOT the sole author (separation of duties at publish, ADR 0056); publish/retract audited. **Anti-rot demotion**: efficacy ratio below a threshold auto-retracts desk status (audited, surfaced to engineers) until re-published.
- **Authoring UI** (extends ISE-302's editor): body editor, envelope builder with the catalogue picker and predicate builder, publish flow showing exactly what the desk will be able to do ("worst case: these ops on these targets"), second-engineer confirmation.

DoD: an engineer can author and (with a second engineer) publish a desk-executable playbook; a solo author cannot; a T3 op cannot enter an envelope; retract + demotion work.