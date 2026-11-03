---
id: 01M6G7B891PKW59YBAVH0D0PAC
created: 2026-11-03T08:10:25.953958Z
updated: 2026-11-03T08:10:27.709596Z
type: task
title: Staging's status worker runs out of memory after the Security Feed deploy, and Beat is close behind — give both more room
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1532
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03).

## What people see

After the Security Feed deploy (5e62bc49), staging's worker pod sits at 4/5 ready: the System status recorder's consumer is killed for running out of memory as it starts (OOMKilled, 256Mi limit, CrashLoopBackOff). System status stops recording while it's down. Beat idles at 305 MB of its 350 MB limit, one module away from the same thing.

**Cause (technical):** every Celery process imports the whole app. Loading it grew by about 50 MB this sprint (266 → 317 MB measured locally), spread across the new models and schemas, not one heavy import. The status consumer's preset limit (256Mi) was set when the app was much smaller.

## Fix

- Status consumer: request 256Mi, limit 512Mi, in both size presets.
- Beat: limit 512Mi, in both presets and the staging overlay.
- Comments record the measurements, as for COM-1191 and COM-1284.

**Chain:** independent (chart only).

**Done when:** on staging the worker pod is 5/5 with no restarts after the deploy, and `kubectl top` shows status and Beat with headroom.