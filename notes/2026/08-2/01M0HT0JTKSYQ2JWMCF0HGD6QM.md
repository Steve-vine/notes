---
id: 01M0HT0JTKSYQ2JWMCF0HGD6QM
created: 2026-08-21T09:21:42.739097Z
updated: 2026-08-21T17:16:01.236008Z
type: task
title: Audit integration-test fixture cost
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 333
sprint: sspwpgk
assignee: steve
label:
- tech_debt
priority: medium
task_status: active
---
Each integration test rebuilds create_app, clears cached singletons, and (verify) may re-run schema setup; the suite added ~25 tests this sprint and the cost multiplies. Profile where per-test seconds go (fixture setup vs test body), move what's safe to per-worker/session scope (schema create, containers are already session-scoped), and document the intended fixture cost model in the test README/conftest.