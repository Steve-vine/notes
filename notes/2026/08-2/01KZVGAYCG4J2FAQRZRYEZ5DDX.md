---
id: 01KZVGAYCG4J2FAQRZRYEZ5DDX
created: 2026-08-12T17:29:18.992851Z
updated: 2026-08-12T17:30:08.578978Z
type: task
title: Brief 006a — Celery + Valkey + scheduled tasks
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 403
sprint: s6nhj1v
assignee: steve
imported_from: linear
label:
- brief
priority: null
task_status: done
---
Valkey via compose, Celery worker + Beat as separate processes, structlog/OTEL parity for tasks, `purge_login_attempts` task on hourly Beat schedule, broker liveness in `/readyz`, dedicated CI integration job. 169 tests, 85.84% coverage.

**Brief spec:** [docs/briefs/006a-celery-valkey-scheduled-tasks.md](<https://github.com/Steve-vine/redvektor/blob/main/docs/briefs/006a-celery-valkey-scheduled-tasks.md>)
**Session summary:** [docs/sessions/006…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-10](https://linear.app/stevevine/issue/DEV-10/brief-006a-celery-valkey-scheduled-tasks)