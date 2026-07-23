---
id: 01KXP53N5TGC65M25J9KYC4KAS
created: 2026-07-16T19:05:30.042225843Z
updated: 2026-07-23T18:34:26.813368Z
type: task
title: Post-execution AI follow-up comment
project: 01KX671DATY39VW6GWK3M2T3DN
number: 95
sprint: s0v93ii
blocked_by:
- 01KXP52NRFDXD3Z6KTDXGFS1G0
assignee: steve
priority: medium
task_status: done
---
ISE-88's **Execute** step ends with "the AI will execute, and post a response once complete, suggesting followup actions." Execution itself is deterministic — no model in the loop (ADR 0017, `tasks/actions/execute.py`) — so the follow-up is a **separate, new AI step** enqueued after `execute_change` finishes.

- After `run_execution` reaches `mark_executed`/`mark_failed` (`execute.py:47-126`), enqueue a short summariser on the `ai` queue. **Idempotent, takes IDs not objects, JSON-serialisable** (Celery rules), and fires on both success and failure.
- It posts a single assistant bubble into the issue conversation/timeline (ISE-91/ISE-92): what was executed, the outcome (with the `before`/rollback state), and suggested next actions — typically "re-analyse to confirm the issue has cleared" (ISE-94). Bounded output, passes redaction (ADR 0010). It **executes nothing**.
- Renders as an AI-coloured bubble at the tail of the timeline, immediately after the execution-result event.

Blocked by the conversation surface it posts into (ISE-91). Relates to the Analyse step (ISE-94) it points the operator toward. Label: feature.