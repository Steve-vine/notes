---
id: 01KX6DKY441NZS7H767CCFQAE4
created: 2026-07-10T16:26:21.188649482Z
updated: 2026-07-21T08:38:50.120473Z
type: task
title: Wire Celery + Redis with heartbeat task
project: 01KX671DATY39VW6GWK3M2T3DN
number: 5
sprint: sh9ng2k
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
comments:
- id: 01KX6NPCH0VPCWNJZPHEJZB96R
  author: Steve Vine
  at: 2026-07-10T18:47:30.079861871Z
  text: 'Development complete on feature/ise-005-celery-redis. PR #7: https://github.com/Steve-vine/ise/pull/7. Celery wired per ADR 0006: Redis broker/backend from ISE_REDIS_URL, JSON-only serialization, UTC, Beat heartbeat every 60s, queue classes scaffolded (sync default; ai/actions routes). Integration test round-trips heartbeat through a real Redis container with a live worker. celery CLI verified (celery -A ISE_api.worker report). redis:7-alpine added to CI pre-pull. PR CI green; staging pipeline green with fresh images in zot. Awaiting smoke test and merge clearance.'
- id: 01KX6PV4R93EX0WW0G7TX7YMNB
  author: Steve Vine
  at: 2026-07-10T19:07:34.536928789Z
  text: 'Smoke tests passed. PR #7 merged to main (9656772), branch deleted. Belt-and-braces main run green, main-tagged images pushed. Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Celery worker + beat against Redis (ADR 0006) with one scheduled heartbeat task proving the queue end-to-end. Tasks idempotent, JSON serialization, IDs not objects.