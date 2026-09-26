---
id: 01M3EH6ZX04SY4N8BN5QZBGKJ3
created: 2026-09-26T09:37:17.728516Z
updated: 2026-09-26T11:27:59.486472Z
type: task
title: System status keeps a record while the workers are stuck — its own recorder, trend charts, and scheduled jobs that are already late are dropped rather than piled up
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 761
sprint: s3nfes0
blocked_by:
- 01M3EH6R6PVZZCSPHR6MB7DNRV
comments:
- id: 01M3EQHN8D9B2SDKGVMCMHWY82
  author: Steve Vine
  at: 2026-09-26T11:27:58.73289Z
  text: |-
    Merged to main in PR #771 (a773b6b).

    System status now has a "Last 6 hours" card with three trend charts:
    - jobs waiting, on each lane
    - how long a job waits before it starts, on each lane
    - average job time

    With these, a queue that is draining looks different from one that is growing. Under the charts, a line says when the newest sample was taken. If the recorder stops, a red "The recorder has stopped" banner says when its last sample was, so the charts don't quietly freeze. Before the first sample, the card says "No record yet".

    The recorder has its own worker. The worker pod gains a small third container, worker-status (about 128 MB), so the recorder keeps running even when the other workers are saturated. It takes a sample every minute and keeps 48 hours of history.

    A late scheduled run is now dropped rather than run late. Every scheduled job expires after its own period, because a newer identical run is already queued behind it; under a backlog, this lets the queue drain. One-off work never expires: access changes, emails, PDFs, Read now and Test connection.

    The database gains one new table, for the samples; there are no data changes. After the deploy, check that the worker pod shows 3/3 containers ready.
assignee: steve
label:
- feature
priority: medium
task_status: review
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