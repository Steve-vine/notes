---
id: 01KYJRJNX5AW77P3MZ479QQTZ8
created: 2026-07-27T21:44:29.349984Z
updated: 2026-07-27T21:50:35.702651Z
type: task
title: 'Pre-approved execution path: playbook-bound changes auto-approve with provenance'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 345
sprint: sf23rna
assignee: steve
label:
- feature
priority: high
task_status: todo
---
The approval actually moves (ADR 0056 amending ADR 0017) — nothing bypasses the choke point; the toll booth relocates.

- A `ProposedChange` created by an interpreted run carries `playbook_id` + the run's `agent_run_id`. If (and only if) the playbook is currently `desk_executable` AND the operation is in its envelope's `allowed_operations` AND the target satisfies `target_scope`, the change transitions straight to approved with audited provenance `pre_approved_via: {playbook, publisher, published_at}` — the self-approval-flag pattern: the trail SAYS it, a reviewer never has to infer it.
- Every guard is re-checked at execution time, not run start (a playbook retracted or demoted mid-run stops approving instantly).
- T3 can never reach here (the envelope can't contain one — belt), but the transition ALSO refuses T3 (braces).
- Protected-targets policy still applies at execution exactly as for any change.
- Existing per-change approval path untouched for everything else; the Approvals screen shows pre-approved changes with their provenance badge rather than hiding them.
- Efficacy: desk executions feed `record_playbook_efficacy` exactly like today (executed-op rule already matches) — the desk loop strengthens the score that gates desk status. Closes the ratchet.

DoD: a responder-triggered in-envelope change executes with no human approver and full provenance in audit + timeline; the same operation outside an envelope still queues for approval; a retracted playbook's in-flight run stops approving.