---
id: 01KX6DMNM9QRPGEPXK8M27ZE6C
created: 2026-07-10T16:26:45.257247189Z
updated: 2026-07-10T16:27:50.512370035Z
type: task
title: Helm chart — API, worker, beat, migration pre-upgrade hook
priority: medium
assignee: steve
task_status: todo
project: 01KX671DATY39VW6GWK3M2T3DN
number: 8
sprint: sh9ng2k
blocked_by:
- 01KX6DKNCP0TJDRGXS8GHHYAKK
- 01KX6DKY441NZS7H767CCFQAE4
- 01KX6DMKFCYDB4VHZMFMPKRRZ3
---
Helm chart deploying API + Celery worker + beat to staging (ADR 0012), with Alembic migrations run as a Helm pre-upgrade hook only — never at container startup (ADR 0005).