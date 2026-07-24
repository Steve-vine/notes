---
id: 01KXBHT6V41A6SQTJ1DQVPVGS0
created: 2026-07-12T16:15:53.188380758Z
updated: 2026-07-24T12:32:43.496578Z
type: task
title: Deterministic change executor (actions queue)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 49
sprint: sdcd2jr
blocked_by:
- 01KXBHSA4S1XGSAHQNTPGEHSD8
- 01KXBHSXM6Q078HBK00GJ5SGC4
assignee: steve
label: null
priority: high
task_status: done
---
tasks/actions/execute.py on the `actions` queue. The queue is ALREADY routed (worker.py:46) and already consumed by the deployed worker (helm/values.yaml:46) — but the ISE_api.tasks.actions module does not exist and is not in worker.py include=[...].

execute_change(change_id) — mirrors tasks/ai/diagnose.py (id in, dict out):
- Guard on status: IDEMPOTENT. Celery may redeliver; a double-execute must be impossible.
- RE-VALIDATE operation + parameters against the live catalogue. Never trust stored params — a row could have been written before a catalogue change.
- Resolve the credential (credentials.reveal, audited) exactly as sync.py does.
- Call connector.act(). Record executed/failed with the result and the `before` snapshot. Audit.
- Degrade-never-block: a connector failure is a `failed` record, not a crashed worker.

NO MODEL IN THE LOOP (ADR 0014): the executor runs exactly the approved parameters. The model proposed; code executes.

Auto-apply path (proposal -> approved -> enqueue immediately) is built and tested, but DORMANT under the default-deny policy from ISE-47.

The executor is NEVER run against the real cluster in CI — act() is mocked at the SDK boundary. Live execution is proven once, deliberately, in the exit test (ISE-53).