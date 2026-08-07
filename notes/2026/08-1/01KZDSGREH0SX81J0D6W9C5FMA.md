---
id: 01KZDSGREH0SX81J0D6W9C5FMA
created: 2026-08-07T09:40:24.657753Z
updated: 2026-08-07T09:40:24.657753Z
type: task
title: 'Platform Log + system health: surface Celery queue backlog and sync staleness'
label: improvement
task_status: backlog
priority: high
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 605
---
On 2026-08-07 the prod `sync` queue in valkey accumulated ~10,000 tasks (backlog began ~2h before the morning host reboot, survived it via valkey persistence, and was self-sustaining at worker concurrency 2). Six systems went hours without an estate sync — while showing `health: connected` and no `last_sync_error`, because no sync ever ran. Nothing appeared in the Platform Log: ISE cannot see its own broker.

Make ISE observe its own task machinery, so this is a screen row instead of a manual `valkey-cli` dig:

- Periodic check (beat sweep, runs outside the congested path or cheap enough to survive it) that warns to the Platform Log when queue depth exceeds a threshold and when any enabled system's `last_synced_at` age exceeds N× its `sync_interval_seconds`.
- Sync staleness should also degrade the system's `health` (connected → degraded), so the single pane of glass stops showing green for systems that are silently starved.
- Consider `expires=` on beat ticks and `sync_system` fan-out so stale periodic tasks are discarded rather than executed — this makes a backlog self-healing and prevents the amplification loop (each stale dispatch tick re-enqueues all starved systems).

UI surface: Platform Log rows cover the warning path; health degradation shows on the existing systems screens — no new screen needed.