---
id: 01KX8GXWT9Q8DGJ7WJHB6RM8VA
created: 2026-07-11T12:02:42.121765884Z
updated: 2026-07-24T12:07:56.599424Z
type: task
title: Sync engine — Beat schedule, snapshot/finding persistence, staleness
project: 01KX671DATY39VW6GWK3M2T3DN
number: 22
sprint: sdm5e08
blocked_by:
- 01KX8GXMA1PVAJ7111FK38PATV
comments:
- id: 01KX8PFD83EXM6WAEQ85SSKQNP
  author: Steve Vine
  at: 2026-07-11T13:39:38.883177376Z
  text: 'Development complete on feature/ise-022-sync-engine. PR #23: https://github.com/Steve-vine/ise/pull/23. Deterministic loop (ISE_api.sync): Beat dispatch_syncs (30s) fans out sync_system per enabled+due system (per-system interval gates work); sync_system reveals credential (audited), calls read_state+detect side-effect-free gathered first, then persists snapshots+findings+status in ONE transaction (atomic, no partial state); findings upsert by (system,source_key) with auto-resolve of cleared findings; connector failure contained (only that system → health=error + sync_failed audit). System.last_synced_at/last_sync_error added (migration 0006); staleness derived. 95/95 tests incl. 8 new sync tests (fake connector) covering persist/idempotent-upsert/resolve/atomic-containment/credential-audit/unregistered-error/due-scheduling. No OpenAPI change (api-types green). Verified live in compose (full Beat→dispatch→sync_system→containment) AND on staging (migration 0006 applied, Beat dispatching every 30s, worker executing dispatched:0 correctly — no registered connector yet). Happy-path sync lands with ISE-23/24. Awaiting smoke test + merge clearance.'
- id: 01KX8PVC51RN8PK29KKTNMZQW5
  author: Steve Vine
  at: 2026-07-11T13:46:10.976677982Z
  text: 'Smoke tests passed. PR #23 merged to main (0c783f4), branch deleted. Belt-and-braces main run green. Done.'
assignee: steve
priority: high
task_status: done
---
Beat fires per-system sync tasks (ADR 0006) → connector read-state/detect → StateSnapshot and Finding persisted atomically (no partial state), findings upserted by source_key. Per-system staleness tracking and last-sync times. Connector errors contained: one system's outage degrades only its card, never others' sync or the UI (connectors brief failure semantics).