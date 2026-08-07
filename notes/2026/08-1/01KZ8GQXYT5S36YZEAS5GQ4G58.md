---
id: 01KZ8GQXYT5S36YZEAS5GQ4G58
created: 2026-08-05T08:30:50.330271Z
updated: 2026-08-07T09:40:35.805854Z
type: task
title: Sync persist deadlocks — concurrent syncs update entity.last_seen_at in opposite orders
project: 01KX671DATY39VW6GWK3M2T3DN
number: 551
sprint: skxht3g
comments:
- id: 01KZ8NM3F2S4HR7AYXTWHYKFK2
  author: Steve Vine
  at: 2026-08-05T09:56:07.778778Z
  text: |-
    Done — PR #467 (feature/ise-551-sync-deadlocks), CI green (backend 6m28s, backend-lint, api-types all pass).

    Cause confirmed as diagnosed: `reconcile_discovered` stamps `last_seen_at` on every entity as it walks the connector's output, and a row lock is held until COMMIT — so the lock order WAS the enumeration order. The three Azure subscriptions share VNets, private endpoints and hosts, enumerate them in different orders, and each ends up waiting on a row the other holds. The per-system advisory lock (ISE-524) does not help here because these are different systems.

    Fix: take every entity row lock the batch needs up front, in one statement, ascending by id — `SELECT id FROM entity WHERE id IN (…) ORDER BY id FOR NO KEY UPDATE`. Postgres puts the LockRows node above the Sort, so rows are locked in sorted order; after that statement the reconcile never waits on an entity row again.

    `FOR NO KEY UPDATE` rather than `FOR UPDATE` deliberately — it is exactly the strength a non-key `UPDATE` already takes, so only the timing and order of the locks change. `FOR UPDATE` would additionally conflict with the KEY SHARE locks an alias/edge/tag insert takes on its parent entity, inventing contention that does not exist today.

    Tests (`tests/integration/test_sync_lock_order.py`), both verified failing with the fix reverted:
    1. the ordered lock is the first entity-row statement, ahead of any UPDATE in connector order;
    2. two overlapping syncs, stepped through the hold-and-wait window with barriers so the race is deterministic — without the fix this raises the exact staging error (`DeadlockDetected … while updating tuple in relation "entity"`).

    Full backend suite green (2289 passed).

    Scope note: this fixes contention on `entity` rows, which is what staging was logging. Other tables written later in the same transaction (`entity_edge` via the group/application rules) could in principle contend too; nothing has been observed there and it is not addressed here. Acceptance is the Platform Log staying free of `sync persist failed … deadlock detected` after deploy.
assignee: steve
label: null
priority: medium
task_status: done
---
The Platform Log on staging shows intermittent `sync persist failed for <system>` warnings (5 between 2026-08-04 17:45 and 2026-08-05 06:59, hitting mgnt-production-uk-pri, mgnt-staging-uk and env-staging-uk). Each one is Postgres `DeadlockDetected`: two concurrently-running syncs both issue `UPDATE entity SET last_seen_at=…` against overlapping entities in different orders, each waits on the other's row lock, and Postgres kills one — that sync's persist fails for the cycle (surfaced via SQLAlchemy's Query-invoked autoflush in `ISE_api.sync`).

Self-healing (the next cycle repairs last_seen_at, no data lost) but it's a real defect in the sync persist path: any two syncs whose estates overlap can lose a cycle to it.

Fix: make the last-seen/persist updates take entities in a deterministic order (e.g. sort by entity id before flushing) so two workers can never acquire row locks in opposite orders. Acceptance: no `sync persist failed … deadlock detected` rows in the Platform Log across overlapping concurrent syncs.