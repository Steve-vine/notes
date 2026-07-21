---
id: 01KXV4XHT1TF92MARARTXZJKZK
created: 2026-07-18T17:38:22.145136551Z
updated: 2026-07-21T08:28:27.70784Z
type: task
title: Incident state machine & lifecycle vocabulary
project: 01KX671DATY39VW6GWK3M2T3DN
number: 119
sprint: stgj737
assignee: steve
priority: high
task_status: done
---
**Sprint 11 (spine) — split from ISE-114.** ISE-114 delivered the load-bearing ADR 0025 behaviour (the durable record no longer flaps with its signal; resolution cascades; genuine recurrence reactivates) on the existing `issue` table + `open/acknowledged/resolved/dismissed` vocabulary. This task matures that record into the full Incident model.

- Introduce the durable **Incident** lifecycle vocabulary: **New / Active / Resolved / Reactivated / Closed** (replacing/aliasing open/ack/resolved/dismissed on the promoted record).
- **Closed auto after *x*-days-quiet**; recurrence after Closed = a new Incident; the correlation key persists on Resolved-but-not-Closed so a recurrence reattaches.
- Repoint the Issues UI vocabulary (coordinate with ISE-117) and the status-transition map.
- Alembic migration; integration tests.

Deferred from ISE-114 by design (the rename touches ~20 files + frontend for no behavioural gain until the model lands). Blocks the stable-key correlation task.