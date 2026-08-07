---
id: 01KZDSGREH0SX81J0D6W9C5FMA
created: 2026-08-07T09:40:24.657753Z
updated: 2026-08-07T11:20:50.821589Z
type: task
title: 'Platform Log + system health: surface Celery queue backlog and sync staleness'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 605
sprint: sgyvvx3
assignee: steve
label:
- improvement
priority: high
task_status: active
---
On 2026-08-07 the prod `sync` queue in valkey accumulated ~10,000 tasks (backlog began ~2h before the morning host reboot, survived it via valkey persistence, and was self-sustaining at worker concurrency 2). Six systems went hours without an estate sync — while showing `health: connected` and no `last_sync_error`, because no sync ever ran. Nothing appeared in the Platform Log: ISE cannot see its own broker.

Two halves — prevention and visibility:

**1. Make backlogs self-healing: `expires=` on periodic tasks.** Beat entries get `options={"expires": <interval>}` and the `sync_system` / `obs_loop_system` fan-out uses `.apply_async(..., expires=interval)`, so the worker discards stale ticks on receipt instead of executing them. A "sync now" request older than its own interval is worthless — another identical one is right behind it. This kills the amplification loop (each stale dispatch tick re-enqueuing every starved system) and would have drained this morning's backlog in minutes unaided. One-off tasks (`deliver_notification`, actions) keep no expiry — they are queued intent, not ticks, and their recovery sweeps already cover broker loss.

**2. Make ISE observe its own task machinery:**
- Periodic check (beat sweep, cheap enough to survive congestion) that warns to the Platform Log when queue depth exceeds a threshold and when any enabled system's `last_synced_at` age exceeds N× its `sync_interval_seconds`.
- Sync staleness also degrades the system's `health` (connected → degraded), so the single pane of glass stops showing green for systems that are silently starved.

UI surface: Platform Log rows cover the warning path; health degradation shows on the existing systems screens — no new screen needed.