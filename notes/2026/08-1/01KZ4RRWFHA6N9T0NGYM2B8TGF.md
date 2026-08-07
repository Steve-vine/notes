---
id: 01KZ4RRWFHA6N9T0NGYM2B8TGF
created: 2026-08-03T21:34:12.465129Z
updated: 2026-08-07T10:06:50.507473Z
type: task
title: Concurrent syncs of one system race on the findings insert — first enable always walks into it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 524
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ67GA5Q3R4BDQCF7NDBXCAM
  author: Steve Vine
  at: 2026-08-04T11:10:54.647872Z
  text: |-
    Built — PR #450, branch feature/ise-524-sync-advisory-lock. No migration, no schema change.

    TOOK YOUR RECOMMENDATION
    `pg_advisory_xact_lock` per system around the persist phase, not the skip-if-running marker — for the reason you gave, plus one more found while writing it: an xact-scoped lock releases on the ROLLBACK in the persist-failure path too, so the ISE-372 containment cannot leave it held. A claimed `syncing` marker would need a TTL precisely because that path exists.

    FOUR THINGS WORTH KNOWING
    1. The lock is taken AFTER the connector's network reads and immediately before the first write. Only the write half serialises, so a slow source never blocks another pass.
    2. READ COMMITTED is what makes waiting sufficient rather than merely polite — once the loser has the lock, its next statements see the winner's committed rows, so its reconcile UPDATES instead of inserting. Worth stating because under REPEATABLE READ the same code would still duplicate.
    3. Two-argument lock form with a fixed class constant, so this cannot silently collide with any other advisory lock the app grows later. `hashtext` is int4 so two systems CAN collide inside the class — one unnecessary wait, never a wrong answer, and it is commented as such.
    4. Your "make it visible" point is in: a contended pass logs that it waited and returns `uncontended: false` in the sync summary.

    THE TEST ACTUALLY REPRODUCES IT
    Four tests, real Postgres, two threads and two sessions — the bug is two TRANSACTIONS racing, so anything sharing a session or a connection cannot express it, and sqlite has no advisory locks at all.

    I removed the lock and ran the main test three times: it failed 3/3. So it reproduces your live failure rather than passing alongside it. That is the check I now do on every regression guard.

    One test you did not ask for, which I think earns its place: the lock is PER SYSTEM. A global lock would queue every sync behind the slowest integration — a worse bug than the one being fixed, and an easy one to introduce in a later refactor.

    VERIFICATION
    Full backend suite 2187 passed; ruff and mypy clean. No frontend change.

    ON YOUR DoD: "no transient error health, no health-transition notice" is asserted directly — the test checks `health != 'error'` and `last_sync_error is None` after both passes complete.
assignee: steve
priority: medium
task_status: done
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
