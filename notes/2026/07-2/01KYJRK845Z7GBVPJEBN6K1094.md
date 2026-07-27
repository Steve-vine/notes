---
id: 01KYJRK845Z7GBVPJEBN6K1094
created: 2026-07-27T21:44:48.005715Z
updated: 2026-07-27T22:23:00.424127Z
type: task
title: 'Interpreted playbook runner: envelope-scoped agent run with deterministic validation'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 346
sprint: sf23rna
comments:
- id: 01KYJTS5WRKQVZP5M58E9ZYDTJ
  author: Steve Vine
  at: 2026-07-27T22:22:59.480707Z
  text: 'Built (PR #320, stacked on #319). run_playbook joins the agent registry with the diagnose agent''s read-only tool surface and a structured plan output — the model plans, never executes, never certifies. run_playbook_flow: pre-flight guards → interpret → plan capped at envelope max_actions → each action through create_proposal + playbook_preapprove (a refusal stops the run; the proposal stays queued for a human) → INLINE run_execution (the queue''s own lock-guarded function, so the responder watches one linear run and validation measures the world the actions produced) → the RUNNER evaluates the envelope predicates against fresh evidence pulls (dot-path addressing, typed comparison, unreachable source = failed check = fail closed) → playbook_run_validated or playbook_run_escalated on the timeline, plus the playbook_run evidence pointer that renders the run like a diagnosis. Responder-tier 202 endpoint with immediate 409s for unpublished/non-matching. Two noted deviations from the task body: (1) the responder watches via the timeline''s existing 10s poll + agent-run events rather than a new SSE stream — the established worker-run pattern, revisit if the walkthrough wants tighter; (2) the envelope token_budget is recorded but the ENFORCED token bound is the run_playbook task-type cap in ai_limits (per-run cap override isn''t in the engine''s contract today). Model config: set the run_playbook task type to the cheap tier in Settings → AI before the acceptance run — an unconfigured type refuses to run. 6 flow tests green with the model faked at the flow''s seams; full gates green.'
assignee: steve
label:
- feature
priority: high
task_status: review
---
The engine (ADR 0056): an in-app AgentRun (new task_type `run_playbook`) that reads the playbook's prose and acts inside the envelope. Reuses the existing agent engine, tool layer and executor — the new parts are the scoping and the checks.

- **Toolset = envelope**: evidence tools scoped to the incident's context + a propose tool restricted to `allowed_operations`/`target_scope` (feeding ISE-345's auto-approval) + nothing else. Enforced at the tool layer, never by prompt.
- **Run bounds** from the envelope: max_actions, wall-clock, token budget — the existing cap/kill machinery (run caps, killed-run transcript capture) applied with per-playbook numbers. Cheap-model tier by default (cost∝difficulty pillar: constrained runbook interpretation is not frontier work).
- **Deterministic validation**: after actions, the RUNNER (not the model) evaluates the envelope's predicates against fresh evidence queries; the model's own claims of success are decoration. Validation outcome → suggested resolve (green) or escalation (red).
- **Escalation**: on any bound trip / validation failure / model stop, follow the envelope's escalation prose: halt, write a summary note to the timeline, flag for an engineer. Never rollback, never improvise past a failure.
- **Semi-supervised**: the run streams to the responder (SSE precedent from chat); step boundaries where the envelope demands confirmation. Nothing lights-out (ADR 0025).
- **Spend**: new `run_playbook` line in the by-task spend breakdown + its own cap in ai_limits — first new AI workload since the viability scare, visible from day one.
- Full transcript recorded on the AgentRun; run + evidence pulls + changes all land on the incident timeline as today.

DoD: on a staging incident with a published test playbook, a responder-triggered run interprets prose, executes one in-envelope T1 op, validates via predicate, and a deliberately-failing validation escalates with a readable summary — all bounded, all on the timeline.