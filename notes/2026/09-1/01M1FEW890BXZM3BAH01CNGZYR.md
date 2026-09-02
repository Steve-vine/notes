---
id: 01M1FEW890BXZM3BAH01CNGZYR
created: 2026-09-01T21:44:19.48839Z
updated: 2026-09-02T22:35:39.864891Z
type: task
title: The Conductor owns all scheduling
project: 01KX671DATY39VW6GWK3M2T3DN
number: 762
sprint: s7nj09w
assignee: steve
label:
- tech_debt
priority: medium
task_status: active
tech: null
---
ADR 0107: one component owns cadence — what runs, how often, and whether it runs at all.

Roughly fourteen beat entries each implement their own dispatch, gating and due-calculation today: syncs, obs loop, approved changes, notifications, report runs, status pages, ticket sweeps, dashboards, system status, stale-run reaping, webhook recovery, estate lifecycle, repo sweeps, heartbeat.

**Why it matters beyond tidiness:** this is where the "disabled means silent" guarantee (ISE-754) becomes expressible once instead of fourteen times. It is also what lets the Differ run per-minute independently of integration polling.

**Headless.** No user-facing surface, unless we decide the Conductor's schedule is worth showing — worth asking, given nothing today shows what is due to run.

**Done when** cadence decisions live in one place and adding a scheduled job means declaring it, not writing another dispatcher.