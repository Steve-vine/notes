---
id: 01KX6DM04JGGNA8TMGDK3FHJV6
created: 2026-07-10T16:26:23.250844646Z
updated: 2026-07-10T16:27:47.218623421Z
type: task
title: Structured logging, redaction pipeline, /healthz and /readyz
task_status: todo
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 6
sprint: sh9ng2k
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
---
Structured JSON logging with the redaction list applied (ADR 0010), no `print()` in app code, plus `/healthz` and `/readyz` endpoints for probes.