---
id: 01KZ8GQXYT5S36YZEAS5GQ4G58
created: 2026-08-05T08:30:50.330271Z
updated: 2026-08-05T08:43:52.544442Z
type: task
title: Sync persist deadlocks — concurrent syncs update entity.last_seen_at in opposite orders
project: 01KX671DATY39VW6GWK3M2T3DN
number: 551
sprint: skxht3g
assignee: steve
priority: medium
task_status: todo
---
The Platform Log on staging shows intermittent `sync persist failed for <system>` warnings (5 between 2026-08-04 17:45 and 2026-08-05 06:59, hitting mgnt-production-uk-pri, mgnt-staging-uk and env-staging-uk). Each one is Postgres `DeadlockDetected`: two concurrently-running syncs both issue `UPDATE entity SET last_seen_at=…` against overlapping entities in different orders, each waits on the other's row lock, and Postgres kills one — that sync's persist fails for the cycle (surfaced via SQLAlchemy's Query-invoked autoflush in `ISE_api.sync`).

Self-healing (the next cycle repairs last_seen_at, no data lost) but it's a real defect in the sync persist path: any two syncs whose estates overlap can lose a cycle to it.

Fix: make the last-seen/persist updates take entities in a deterministic order (e.g. sort by entity id before flushing) so two workers can never acquire row locks in opposite orders. Acceptance: no `sync persist failed … deadlock detected` rows in the Platform Log across overlapping concurrent syncs.