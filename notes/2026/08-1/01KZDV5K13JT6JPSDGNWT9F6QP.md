---
id: 01KZDV5K13JT6JPSDGNWT9F6QP
created: 2026-08-07T10:09:15.811609Z
updated: 2026-08-07T10:56:01.696849Z
type: task
title: 'System Status screen: ISE observing its own machinery'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 607
sprint: sgyvvx3
assignee: steve
priority: high
task_status: todo
---
New screen at `/system-status`, top of the **System** nav section — answers "is ISE itself doing its job right now, and if not, where is it stuck?". Full design in the UI brief, **section 12** (`docs/briefs/ui-brief.md`). Motivated by the 2026-08-06/07 sync-queue backlog: ~10k tasks banked in valkey over ~19 hours while every surface showed green.

One vertical slice:

- **Collector**: cheap beat sweep sampling queue depths (`LLEN` per queue), worker stats (nodes, active tasks, throughput, avg task duration) into a small samples table. Must not queue behind the congestion it reports (own queue or equivalent isolation). ISE-605's warning thresholds read from this same collector — one collector, two consumers; build here, let ISE-605 consume.
- **API**: `/api/v1/system-status` serving tiles + panels (queue trends, sync/obs staleness ratios from the `system` table, Platform Log 24h pulse via the grouped read, AI runs/spend).
- **Screen**: verdict tiles (Beat / Worker / Queues / Database / Syncs — `statusColors.ts` ladder, status word always written), task-machinery panel with sparklines and a "running now" list, sync-freshness table sorted worst-first, Platform Log pulse, AI activity. Polls ~10s with stale-data indicator.
- **Nav entry** added to the System section (front door, ahead of Agent runs / Platform log / Audit).

Excluded by design: host-level metrics (DataDog's job) and monitored-estate state (every other screen's job).

Related: ISE-605 (expiry + warnings — consumes this collector), ISE-606 (connector timeouts — prevents the failure mode this screen makes visible).