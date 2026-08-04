---
id: 01KZ4RRWFHA6N9T0NGYM2B8TGF
created: 2026-08-03T21:34:12.465129Z
updated: 2026-08-04T10:59:33.489179Z
type: task
title: Concurrent syncs of one system race on the findings insert — first enable always walks into it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 524
order: 1.0
sprint: skxht3g
assignee: steve
priority: medium
task_status: active
---
Live-found 2026-08-03 when Steve enabled the EntraID integration after the estate wipe: the first sync failed with a raw `UniqueViolation` surfaced as the system's sync error, then self-healed on the next pass.

## What happened (worker logs, 21:13–21:14 UTC)

- **21:13:56 and 21:13:58 — two sync passes for the same system started 2s apart.** Enabling triggered one (`trigger_sync` in `api/v1/systems.py:167` just `.delay()`s), and the beat tick enqueued another — the nuke had nulled `last_synced_at`, so the system was immediately due (`sync.py` dispatch). Nothing anywhere provides per-system mutual exclusion.
- Both passes read the empty findings table, both built the same 12 identity-protection alerts; the loser hit `uq_finding_system_id` on `riskyuser/fdbb1cf5…` at 21:14:11. The ISE-372 containment rolled back, stamped `health=error` with the full psycopg traceback as `last_sync_error`, and fired the health-transition notice.
- The winner (21:14:33) persisted everything and cleared the error.

## Why this is not the known duplicate case

`_reconcile_findings` (`sync.py:73`) already handles the same `source_key` twice **within** a batch — a first-seen row is registered into `existing` so the duplicate updates it, with a comment naming this exact constraint (the k8s double-`Failed`-event case). What is missing is exclusion **across** concurrent syncs of one system: both transactions `select(Finding)` before either commits, so both insert.

## Why it matters despite self-healing

- **Every enable-after-reset walks into it deterministically** — enable-triggered sync + immediately-due beat tick is the standard first-enable sequence. Steve hit it on the first integration enabled after the wipe.
- The operator sees a raw psycopg traceback and an `error` health tile for what is really "two syncs raced"; it reads as a broken integration during exactly the moment (first setup) trust is being formed.
- The loser's whole persist rolls back — with more unlucky interleaving (loser commits entities first, winner later?) the failure mode could get less benign as connectors grow.

## Proposed fix — decide in plan mode

- **`pg_advisory_xact_lock(hashtext(system_id::text))`** at the top of the persist transaction — second sync blocks until the first commits, then its reconcile sees the winner's rows and updates instead of inserting. Small, no schema change, keeps both syncs' work.
- Alternative: skip-if-running at dispatch (a claimed `syncing` marker) — avoids the duplicate work entirely but adds state that can wedge if a worker dies mid-claim; needs a TTL.
- The advisory lock is the recommendation: the duplicate sync is rare and cheap, the wedge risk is not worth the state.

Also worth doing whichever lands: `trigger_sync` and the beat dispatch could both note in the sync counts/log when a pass found the lock held, so a race that does occur is visible as "waited for concurrent sync", not silence.

## Definition of done

Enabling a never-synced (or just-reset) system with the beat scheduler live produces one clean first sync — no `UniqueViolation`, no transient `error` health, no health-transition notice — verified by a test that runs two `sync_system` calls for one system concurrently against a real Postgres (testcontainers, per ADR 0016).
