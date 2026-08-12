---
id: 01KZVGAYCG4J2FAQRZRYEZ5DDX
created: 2026-08-12T17:29:18.992851Z
updated: 2026-08-12T17:29:18.992851Z
type: task
title: Brief 006a — Celery + Valkey + scheduled tasks
label: brief
assignee: steve
task_status: done
imported_from: linear
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 403
---
Valkey via compose, Celery worker + Beat as separate processes, structlog/OTEL parity for tasks, `purge_login_attempts` task on hourly Beat schedule, broker liveness in `/readyz`, dedicated CI integration job. 169 tests, 85.84% coverage.

**Brief spec:** [docs/briefs/006a-celery-valkey-scheduled-tasks.md](<https://github.com/Steve-vine/redvektor/blob/main/docs/briefs/006a-celery-valkey-scheduled-tasks.md>)
**Session summary:** [docs/sessions/006…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-10](https://linear.app/stevevine/issue/DEV-10/brief-006a-celery-valkey-scheduled-tasks)