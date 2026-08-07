---
id: 01KZDSGREH0SX81J0D6W9C5FMA
created: 2026-08-07T09:40:24.657753Z
updated: 2026-08-07T11:31:20.868229Z
type: task
title: 'Platform Log + system health: surface Celery queue backlog and sync staleness'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 605
sprint: sgyvvx3
comments:
- id: 01KZDZVPA0HYYR1FZTMSDPZ2DC
  author: Steve Vine
  at: 2026-08-07T11:31:14.368791Z
  text: |-
    Built — PR #513 (feature/ise-605-backlog-visibility), stacked on #512. ADR 0091 amended.

    Half 1, prevention — expiry, done a bit wider than the task described. Rather than adding `expires` entry by entry, every beat entry gets `options={"expires": <its own schedule>}` uniformly at the schedule level, so a connector-declared sweep (ADR 0085) inherits it without knowing about it — the per-entry version is the one the next sweep forgets. The two fan-outs pass each system's own interval to `apply_async`. One-off tasks untouched exactly as specced: an action / notification / AI run is queued INTENT, and an expiry there loses work rather than shedding it. Pinned by a test on the SHAPE (only beat entries expire) rather than by a list, so a new one-off task cannot be added to a schedule by accident.

    Half 2, visibility — both checks ride the ISE-607 collector on the isolated `status` queue, which matters more than it sounds: a warning about a backlog must not be queued behind that backlog.

    - Queue depth warns at 200 and errors at 1000, EDGE-triggered against the previous sample. This was the trap worth catching: level-triggered on a 30-second collector, the real outage would have produced ~2,300 identical rows in the one surface whose entire value is that a row in it means something (ADR 0077). Nothing is logged on the way back down — recovery is not an incident.
    - Staleness degrades `connected` → `degraded` past 3× a system's own interval, with the ratio and the reason in `extra`. Three constraints keep it honest: only `connected` is degraded (an `error` system is telling a more specific story and losing a diagnosis for a symptom is a downgrade); nothing here ever CLEARS a degradation, because a clock cannot know an integration is healthy — only a sync that completed can, and it writes the connector's own health; and it is edge-triggered by construction, since an already-degraded system is not a candidate.

    Never-synced is treated as the worst case rather than as a missing measurement — the null ratio has to skip the threshold comparison or an enabled system that has never once synced falls straight through the check, which is precisely the shape six systems were in.

    No new screen, as the task specified: Platform Log rows carry the warning path, and `degraded` shows on the existing systems screens and on the new status screen.

    Tests: `test_periodic_task_expiry.py` (3) + `test_backlog_warnings.py` (10, real Postgres), covering the silent-on-the-way-down, first-sample-ever, error-keeps-its-story, disabled-is-not-a-fault and recovery-belongs-to-the-sync cases. ruff, mypy strict and the 718-test unit suite green.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
On 2026-08-07 the prod `sync` queue in valkey accumulated ~10,000 tasks (backlog began ~2h before the morning host reboot, survived it via valkey persistence, and was self-sustaining at worker concurrency 2). Six systems went hours without an estate sync — while showing `health: connected` and no `last_sync_error`, because no sync ever ran. Nothing appeared in the Platform Log: ISE cannot see its own broker.

Two halves — prevention and visibility:

**1. Make backlogs self-healing: `expires=` on periodic tasks.** Beat entries get `options={"expires": <interval>}` and the `sync_system` / `obs_loop_system` fan-out uses `.apply_async(..., expires=interval)`, so the worker discards stale ticks on receipt instead of executing them. A "sync now" request older than its own interval is worthless — another identical one is right behind it. This kills the amplification loop (each stale dispatch tick re-enqueuing every starved system) and would have drained this morning's backlog in minutes unaided. One-off tasks (`deliver_notification`, actions) keep no expiry — they are queued intent, not ticks, and their recovery sweeps already cover broker loss.

**2. Make ISE observe its own task machinery:**
- Periodic check (beat sweep, cheap enough to survive congestion) that warns to the Platform Log when queue depth exceeds a threshold and when any enabled system's `last_synced_at` age exceeds N× its `sync_interval_seconds`.
- Sync staleness also degrades the system's `health` (connected → degraded), so the single pane of glass stops showing green for systems that are silently starved.

UI surface: Platform Log rows cover the warning path; health degradation shows on the existing systems screens — no new screen needed.