---
id: 01M3EH6ZX04SY4N8BN5QZBGKJ3
created: 2026-09-26T09:37:17.728516Z
updated: 2026-09-26T09:37:17.728516Z
type: task
title: System status keeps a record while the workers are stuck — its own recorder, trend charts, and scheduled jobs that are already late are dropped rather than piled up
task_status: todo
assignee: steve
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 761
---
Third of three System status tasks (ADR 0077 §4–5). Stacks on COM-760.

**Behaviour.**
- The lane and worker figures on System status gain **trend charts** for the last few hours: jobs waiting, wait time, and average job time. A long queue that is draining and one that is growing look different at a glance. Average job time is the early warning, because it rises before a queue visibly grows.
- The screen says how fresh its own record is. If the recorder has stopped, the screen shows that instead of freezing on its last good reading.
- **A scheduled job already late by its own period is dropped when it's picked up, not run late.** An identical, newer one is already queued behind it. Under a backlog this makes the queue drain instead of amplifying itself. **One-off work is never dropped:** access changes, emails, PDFs, a Read now or a Test connection.

**Mechanism.**
- **The recorder runs where the congestion can't reach it.** It's a Beat task, every minute, on a new `status` queue served by a **third consumer container in the worker pod** (concurrency 1, small resources, `worker.status` in the chart). This follows the precedent of the `execution` consumer (COM-275). It samples the Valkey keys from COM-759 into a new `system_status_sample` table, pruned to 48 h on the same pass. The pool is what saturates, so a separate queue alone is not enough.
- **A test pins the wiring:** the route, the chart's consumer and `compose.yaml` must all name the `status` queue. A queue nothing consumes is a silent failure.
- **Expiring ticks:** every Beat entry gets `options={"expires": <its own period>}`; for a crontab, the gap to its next firing. Tasks dispatched by the API or other tasks carry no expiry.
- Alembic migration for the samples table; follow the enum/naming memories.