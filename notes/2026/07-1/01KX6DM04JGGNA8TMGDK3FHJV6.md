---
id: 01KX6DM04JGGNA8TMGDK3FHJV6
created: 2026-07-10T16:26:23.250844646Z
updated: 2026-07-23T19:46:00.495022Z
type: task
title: Structured logging, redaction pipeline, /healthz and /readyz
project: 01KX671DATY39VW6GWK3M2T3DN
number: 6
sprint: sh9ng2k
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
comments:
- id: 01KX6QFS02PPMT51ZGS9GYTGVK
  author: Steve Vine
  at: 2026-07-10T19:18:50.626605007Z
  text: 'Development complete on feature/ise-006-logging-health. PR #8: https://github.com/Steve-vine/ise/pull/8. JSON logging + central redaction per ADR 0010 (sensitive keys recursively; Bearer/DSN/AWS-key/query-param patterns), one configure_logging for API + Celery, new serve.py entrypoint routes uvicorn server AND access logs through the pipeline (image CMD updated). /healthz + /readyz outside /api/v1, readyz does a real DB check with 3s bound. Live verification caught a real leak — /readyz?token=... appeared verbatim in access logs — fixed with the key=value pattern and regression-tested. PR CI green (frontend correctly path-skipped); staging pipeline green, images built. Awaiting smoke test and merge clearance.'
- id: 01KX6QRM17DY6WTM416GZKZSJB
  author: Steve Vine
  at: 2026-07-10T19:23:40.455843066Z
  text: 'Smoke tests passed. PR #8 merged to main (3077ab7), branch deleted. Belt-and-braces main run green (frontend path-skipped, main-tagged images pushed). Done.'
assignee: steve
priority: medium
task_status: done
---
Structured JSON logging with the redaction list applied (ADR 0010), no `print()` in app code, plus `/healthz` and `/readyz` endpoints for probes.