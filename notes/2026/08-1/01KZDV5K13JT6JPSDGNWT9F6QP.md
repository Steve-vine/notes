---
id: 01KZDV5K13JT6JPSDGNWT9F6QP
created: 2026-08-07T10:09:15.811609Z
updated: 2026-08-13T19:00:28.719225Z
type: task
title: 'System Status screen: ISE observing its own machinery'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 607
sprint: sgyvvx3
comments:
- id: 01KZDZ8BK4AHM58ER0NMD9854K
  author: Steve Vine
  at: 2026-08-07T11:20:40.803962Z
  text: |-
    Built — PR #512 (feature/ise-607-system-status), ADR 0091.

    Screen at /system-status, first item in the System nav section. Vertical slice as designed:

    - Collector: beat-scheduled task sampling queue depths, worker ping and DB connection headroom into `system_status_sample` (migration 0100, pruned to 48h). Isolated properly — its own `status` queue AND its own worker deployment (statusWorker, 1 replica / concurrency 1). A queue split alone would not have been enough: a queue shares the worker POOL, and the pool is what saturated on 2026-08-07. On the shared pool the collector would have been the 10,001st task in the backlog it exists to describe.
    - Worker telemetry is written, never interrogated: celery task_prerun/postrun handlers keep running-tasks / recent-durations / a completed counter in Redis, and every read is a plain Redis command. Deliberately NOT `celery inspect` — that is a broadcast that waits for a reply, so it times out in exactly the state the screen exists for. Every telemetry write is wrapped: instrumentation must never take a task down.
    - The `heartbeat` task now stamps its execution time, and the Worker tile reads the AGE of that stamp — delivery lag on the default queue. That is the number the outage was invisible to: liveness was true for all 19 hours while the queue was 10k deep.
    - API `GET /api/v1/system-status` (viewer-visible): five verdict tiles (Beat/Worker/Queues/Database/Syncs), per-queue depth + trend, running-now, sync freshness, Platform Log 24h pulse, AI runs/spend. Thresholds are served alongside the verdicts so ISE-605's warnings cannot disagree with the tiles.

    Two design points worth recording:
    - Staleness is a RATIO of each system's own interval, never an age — a 12-hour integration 40 minutes late is fine, a 5-minute one is starved, and sorting by age ranks them identically. Never-synced sorts ahead of every ratio: never is worse than late, and rendering it as a blank cell is how it was missed the first time.
    - `unknown` is a first-class verdict. An unreadable broker reads "unknown", never a confident 0 that renders as a calm green queue — reproducing the confident-green failure inside the screen built to end it would be the funniest possible outcome.

    Tests: 14 backend integration tests (real Postgres + real Redis) pinning the 2026-08-07 shape — a starved system visible AS starved while it still reports `connected`, ratio-not-age ordering, unreachable-broker = unknown — plus a wiring test that pins the routing, the chart and compose against each other (a queue nothing consumes is a silent failure). 7 frontend tests over the same payload. ruff, mypy strict, vitest (651), build and prettier all green.

    Note: ADR renumbered 0090 → 0091, as PR #511 (ISE-596) claimed 0090 first.
- id: 01KZE24CAD3HCFKMC578M269CR
  author: Steve Vine
  at: 2026-08-07T12:10:56.205611Z
  text: |-
    Deployed to staging 2026-08-07 (run 31176759374, all jobs green — combined-check, build-images, deploy-staging).

    Verified live in the cluster rather than just by run colour:
    - `ise-status-worker` deployment Running, consuming only the `status` queue.
    - Collector executing on cadence: `{'queue_depths': {'sync': 0, 'ai': 0, 'actions': 0, 'status': 0}, 'workers_online': 2, 'backlog_warning': None, 'degraded': [], 'pruned': 0}`.
    - Migration `0101` applied (restacked from 0100 — sprint 55 took that number an hour before release); `system_status_sample` filling on the 30s cadence.
    - Worker telemetry keys present in valkey — `ise:status:completed` = 21, `ise:status:durations` carrying real per-task times (0.005s to 11.3s), `ise:status:heartbeat` stamped.
    - `GET /api/v1/system-status` routed and role-gated (401 unauthenticated).

    Rebased onto the new main after sprint 55 released; PR #512 fully green post-rebase. UI smoke test of /system-status is yours.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
New screen at `/system-status`, top of the **System** nav section — answers "is ISE itself doing its job right now, and if not, where is it stuck?". Full design in the UI brief, **section 12** (`docs/briefs/ui-brief.md`). Motivated by the 2026-08-06/07 sync-queue backlog: ~10k tasks banked in valkey over ~19 hours while every surface showed green.

One vertical slice:

- **Collector**: cheap beat sweep sampling queue depths (`LLEN` per queue), worker stats (nodes, active tasks, throughput, avg task duration) into a small samples table. Must not queue behind the congestion it reports (own queue or equivalent isolation). ISE-605's warning thresholds read from this same collector — one collector, two consumers; build here, let ISE-605 consume.
- **API**: `/api/v1/system-status` serving tiles + panels (queue trends, sync/obs staleness ratios from the `system` table, Platform Log 24h pulse via the grouped read, AI runs/spend).
- **Screen**: verdict tiles (Beat / Worker / Queues / Database / Syncs — `statusColors.ts` ladder, status word always written), task-machinery panel with sparklines and a "running now" list, sync-freshness table sorted worst-first, Platform Log pulse, AI activity. Polls ~10s with stale-data indicator.
- **Nav entry** added to the System section (front door, ahead of Agent runs / Platform log / Audit).

Excluded by design: host-level metrics (DataDog's job) and monitored-estate state (every other screen's job).

Related: ISE-605 (expiry + warnings — consumes this collector), ISE-606 (connector timeouts — prevents the failure mode this screen makes visible).