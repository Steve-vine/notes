---
id: 01KX6DKY441NZS7H767CCFQAE4
created: 2026-07-10T16:26:21.188649482Z
updated: 2026-07-10T16:34:32.03010558Z
type: task
title: Wire Celery + Redis with heartbeat task
task_status: backlog
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 5
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
sprint: sh9ng2k
---
Celery worker + beat against Redis (ADR 0006) with one scheduled heartbeat task proving the queue end-to-end. Tasks idempotent, JSON serialization, IDs not objects.