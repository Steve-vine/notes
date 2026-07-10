---
id: 01KX6VXVPJGWSDV0M5XYA3EX00
created: 2026-07-10T20:36:26.450042548Z
updated: 2026-07-10T20:38:02.136304209Z
type: task
title: Audit event pipeline — same-transaction writes
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 11
sprint: sqtx330
---
AuditEvent writes committed in the same transaction as the change they record (roadmap Phase 1). Helper API for services; heavy test investment — this is a Phase 4 trust anchor.