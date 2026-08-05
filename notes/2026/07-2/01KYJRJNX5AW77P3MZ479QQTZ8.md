---
id: 01KYJRJNX5AW77P3MZ479QQTZ8
created: 2026-07-27T21:44:29.349984Z
updated: 2026-08-05T13:39:16.37458Z
type: task
title: 'Pre-approved execution path: playbook-bound changes auto-approve with provenance'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 345
order: -2.0
sprint: sf23rna
comments:
- id: 01KYJT8741NCW0Y8C4H4ANX1K9
  author: Steve Vine
  at: 2026-07-27T22:13:43.681754Z
  text: 'Built (PR #319, stacked on #318, migration 0067). proposed_change.playbook_id FK (SET NULL on delete — the audit trail keeps the provenance). changes.playbook_preapprove spends the publish-time approval with every guard re-checked AT THE TRANSITION, not run start: desk_state still desk_executable (retraction/demotion bites an in-flight run instantly), operation ∈ envelope allowed_operations, T3 refused even if an envelope somehow contained one (belt and braces — tested by forcing a corrupted envelope), and the target re-checked against the incident-derived binding (namespace entity → params.namespace must equal it; workload → name+namespace; manual incidents with no resolvable entity fail closed). decided_by is set to the playbook''s PUBLISHER — the human whose approval is being spent — and the audit details carry pre_approved_via {playbook, publisher, published_at}, the self-approval-flag pattern. PreapprovalRefused never discards the proposal: the change stays on the ordinary approval path for a human, which is what the runner escalates to. UI: "pre-approved · playbook" badge on the Approvals table decided-by cell and the timeline change card. 6 direct-DB integration tests + migration parity green; full mypy/ruff/build green.'
assignee: steve
priority: high
task_status: done
---
The approval actually moves (ADR 0056 amending ADR 0017) — nothing bypasses the choke point; the toll booth relocates.

- A `ProposedChange` created by an interpreted run carries `playbook_id` + the run's `agent_run_id`. If (and only if) the playbook is currently `desk_executable` AND the operation is in its envelope's `allowed_operations` AND the target satisfies `target_scope`, the change transitions straight to approved with audited provenance `pre_approved_via: {playbook, publisher, published_at}` — the self-approval-flag pattern: the trail SAYS it, a reviewer never has to infer it.
- Every guard is re-checked at execution time, not run start (a playbook retracted or demoted mid-run stops approving instantly).
- T3 can never reach here (the envelope can't contain one — belt), but the transition ALSO refuses T3 (braces).
- Protected-targets policy still applies at execution exactly as for any change.
- Existing per-change approval path untouched for everything else; the Approvals screen shows pre-approved changes with their provenance badge rather than hiding them.
- Efficacy: desk executions feed `record_playbook_efficacy` exactly like today (executed-op rule already matches) — the desk loop strengthens the score that gates desk status. Closes the ratchet.

DoD: a responder-triggered in-envelope change executes with no human approver and full provenance in audit + timeline; the same operation outside an envelope still queues for approval; a retracted playbook's in-flight run stops approving.