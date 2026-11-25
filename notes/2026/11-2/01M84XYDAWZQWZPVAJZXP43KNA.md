---
id: 01M84XYDAWZQWZPVAJZXP43KNA
created: 2026-11-23T19:25:52.860829Z
updated: 2026-11-25T09:17:31.713617Z
type: task
title: 'Restore option 1: Everything — the whole database goes back to the copy, logs included, with a safety copy first and no change to live data until the copy has been checked'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2118
sprint: szwetpq
blocked_by:
- 01M84XXEFMFJGW424C95Z9M2ZK
- 01M84XXPNAEX9CBTGXYT6F1CVZ
- 01M84XY3275Z2QQ3TPQDGPY765
comments:
- id: 01M85K7NJ7PSKMPVC8PPDE34B5
  author: Steve Vine
  at: 2026-11-24T01:37:56.295277Z
  text: |-
    Merged: #2114, c27e413df, 24 Nov 01:36 GMT. Migration 0906_database_restores. Not on staging yet: the sprint deploys together.

    Built: Restore ▸ Everything, and the engine the other restores and the recovery command will reuse. It shows what will be lost, takes a safety copy, rebuilds the copy out of sight, brings it up to date, checks it, places the hold, and only then swaps it in with one short step.

    For Steve to read: ADR 0170 (how the swap works). It amends ADR 0169 §4, because the planned approach of renaming the database's schema failed when tested with Compass's real permissions. The build marked it Accepted; I've set it back to Proposed until you've read it.

    Decisions made in the build:
    - The copy is brought up to date and given its hold BEFORE the swap, so a failed upgrade costs nothing and restored data never exists without its hold.
    - A deployment and a restore now keep out of each other's way: a migration waits for a restore, and a restore refuses to start during one.
    - Decision and audit finding numbers had no counter and would have been reissued. They are now protected too.
    - "Go on without a safety copy" is an unticked box on the restore dialog.
    - The Admin follows progress through a private link, because they are signed out as well.

    Tested: real Postgres with Compass's real permission shape and default limits, 300k rows in about 30s. The restore was killed outright at every step: before the swap, live data was unchanged and parked work came back; just after it, the restored data and hold were in place. An independent review found 10 defects, 3 of them high, and all are fixed.

    Couldn't check yet: a restore on a real deployment or database cluster (COM-2124), and the screens in a browser.

    Known limit: a pod cut off from Valkey can still write between the safety copy and the swap. Those writes are lost and aren't in the safety copy.

    For the release: the database needs free disk for a second full copy plus its logs while a restore runs. Compass can't check this, so production's headroom must be confirmed first.
- id: 01M872A60XKF6BKV9GEYHYHH2T
  author: Steve Vine
  at: 2026-11-24T15:20:41.757324Z
  text: |-
    Pre-UAT pass, 24 Nov 2026, staging 0234a65f3.

    Couldn't check on staging, by design: every Done when item. The task itself says a restore runs on a scratch Compass, never staging's shared data. No Everything restore was started.

    Where it was proved instead: COM-2124 Phase B on build e034eaeed. Results in ~/compass-uat/backup-and-restore/COM-2124/logs/phase-b-summary.md.
    - Scenario 2, Everything from BKP-4, PASS in 126.8 s: 522 of 529 tables identical to the moment of the copy, Compass worked afterwards and came up on hold.
    - Scenario 6, killed part way, PASS: killed at stopping, safety, rebuilding and checking, each time back exactly as it was.

    What I saw in the browser on staging:
    - Restore ▸ Everything is on each Ready copy's Restore menu, next to Keep audit logs and Open to compare (COM-2121/01-restore-menu.png).
    - I didn't open its dialog. My session's permission checks refused even the menu click once, and opening a restore dialog wasn't needed.
assignee: steve
label:
- feature
priority: high
task_status: done
---
ADR 0169 §3, §4, §8. The nuclear option, and the restore engine the other full restore and the recovery command reuse.

**Chain:** on the chain — API.

**What people see**

- On a copy, **Restore ▸ Everything** shows what will be lost, in numbers: how long since the copy, and how many records, log entries and files have changed. It says plainly that **logs since the copy will be lost**.
- The Admin gives a reason and types the BKP number.
- Compass goes into maintenance, shows each step's progress to that Admin, and comes back on hold at the review.
- A copy from a newer Compass is refused, naming the version to deploy first. A copy from an older one is restored and brought up to date.

**Done when**

- A restore on a **scratch Compass** (never staging's shared data, see COM-2124) returns the data to the copy exactly, checked by row counts and a sample of records, and Compass works afterwards.
- A safety copy (a normal BKP, marked as such) exists first, and restoring it undoes the restore.
- **Killing the restore at any step before the swap leaves Compass exactly as it was.**
- Reference numbers are not reissued: counters end at the higher of the copy and the live data whenever the live data can be read.
- The restore's own record survives it, in the activity log and on the copy.

**Technical notes**

- Build beside the live data and swap. The cluster definitions make `compass` the database owner with no create-database right shown, so assume **a separate schema in the same database**, renamed on swap. **Confirm this first** on a CNPG cluster, including `pg_trgm` and the 13 sequences.
- Restore runs in the backup worker. The swap must be one transaction.
- The Alembic upgrade after an older copy has to run from the restore, given migrations otherwise run only from the Helm hook (ADR 0005). Say in the PR how that squares with the hard rule: it is not container startup, but make it explicit.
- Counters to protect: the 13 sequences, `evidence_counters`, `register_entry_counters`.
- The store setting row is inside the restored data. Carry the running store config through so the restore doesn't lose sight of the bucket.