---
id: 01KYJRK845Z7GBVPJEBN6K1094
created: 2026-07-27T21:44:48.005715Z
updated: 2026-07-27T21:44:48.005715Z
type: task
title: 'Interpreted playbook runner: envelope-scoped agent run with deterministic validation'
label: feature
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 346
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