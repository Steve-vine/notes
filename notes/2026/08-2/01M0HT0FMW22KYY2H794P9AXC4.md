---
id: 01M0HT0FMW22KYY2H794P9AXC4
created: 2026-08-21T09:21:39.484958Z
updated: 2026-08-21T09:22:43.62034Z
type: task
title: 'Split backend-test: unit and integration as parallel jobs, shard integration'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 332
sprint: sspwpgk
blocked_by:
- 01M0HSZ4CJCS5AEBZV3RCXBRK5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
backend-test (~15.5 min) runs the unit suite then the integration suite sequentially in one job. Split them into parallel jobs, and shard the integration suite into two (stable split by test file) so the critical path halves again. Depends on runner concurrency (COM-326) actually allowing the jobs to run side by side — sharding on a one-job runner just queues.