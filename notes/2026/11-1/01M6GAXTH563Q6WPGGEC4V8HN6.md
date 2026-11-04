---
id: 01M6GAXTH563Q6WPGGEC4V8HN6
created: 2026-11-03T09:13:00.197522Z
updated: 2026-11-04T07:46:09.223853Z
type: task
title: The hourly mail-list sync no longer fits in the worker's memory since the Security Feed deploy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1540
sprint: s6xh9g1
comments:
- id: 01M6GEBC738SXF9QPVYCYQR739
  author: Steve Vine
  at: 2026-11-03T10:12:50.019428Z
  text: |-
    Done: PR #1552 merged (6a266519), deployed to staging at 09:20. Browser smoke 25 passed.

    The main worker's limit is now 1536Mi (from 1Gi) in the production preset and the staging overlay.

    Pre-UAT (staging): **Passed** on the first run.
    - The 10:10 list sender sync finished "ok" in 153 s. Its last finish before this was 07:12.
    - The worker peaked at 990Mi during it, against the 1Gi limit that killed it at 09:12, and had 0 restarts.

    I'll confirm the 11:10 run too.
- id: 01M6GYTQBWNBWAHSWGCWTYHWJN
  author: Steve Vine
  at: 2026-11-03T15:00:50.172225Z
  text: 'Pre-UAT, second check: **Passed**. Every hourly list sender sync since the fix has finished "ok" (10:10, 11:10 … 14:10), and the worker pod has had 0 restarts in the four hours since its last deploy.'
assignee: steve
label: null
priority: medium
task_status: done
---
Found in the sprint 102 pre-UAT (2026-11-03).

## What people see

On staging, the hourly sync of who may send to distribution lists last finished at 07:12 (the build before the Security Feed). The 08:10 run never finished. At 09:10 the main worker was killed for running out of memory (OOMKilled at its 1Gi limit) part-way through the sync, as a directory sync started. Anything else running on that worker at the time is lost and retried later.

**Cause (technical):** every worker process imports the whole app, which grew ~50 MB this sprint (COM-1532). The main consumer runs two such children, and the list sender sync was already close to the 1Gi limit, so it now tips over.

## Fix

- Main worker: limit 1536Mi (from 1Gi) in both size presets and the staging overlay, with the measurement in the comment.

**Chain:** independent (chart only).

**Done when:** on staging, the :10 list sender sync finishes (System status shows it ok) and the worker has no OOM restarts across two runs.