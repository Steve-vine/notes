---
id: 01M6GAXTH563Q6WPGGEC4V8HN6
created: 2026-11-03T09:13:00.197522Z
updated: 2026-11-03T09:13:05.918421Z
type: task
title: The hourly mail-list sync no longer fits in the worker's memory since the Security Feed deploy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1540
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03).

## What people see

On staging, the hourly sync of who may send to distribution lists last finished at 07:12 (the build before the Security Feed). The 08:10 run never finished. At 09:10 the main worker was killed for running out of memory (OOMKilled at its 1Gi limit) part-way through the sync, as a directory sync started. Anything else running on that worker at the time is lost and retried later.

**Cause (technical):** every worker process imports the whole app, which grew ~50 MB this sprint (COM-1532). The main consumer runs two such children, and the list sender sync was already close to the 1Gi limit, so it now tips over.

## Fix

- Main worker: limit 1536Mi (from 1Gi) in both size presets and the staging overlay, with the measurement in the comment.

**Chain:** independent (chart only).

**Done when:** on staging, the :10 list sender sync finishes (System status shows it ok) and the worker has no OOM restarts across two runs.