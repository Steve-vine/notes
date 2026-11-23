---
id: 01M84XYDAWZQWZPVAJZXP43KNA
created: 2026-11-23T19:25:52.860829Z
updated: 2026-11-23T19:27:12.172919Z
type: task
title: 'Restore option 1: Everything — the whole database goes back to the copy, logs included, with a safety copy first and no change to live data until the copy has been checked'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2118
sprint: szwetpq
assignee: steve
label:
- feature
priority: high
task_status: todo
---
ADR 0169 §3, §4, §8. The nuclear option, and the restore engine the other full restore and the recovery command reuse.

**Chain:** on the chain — API.

**What people see**

- On a copy, **Restore ▸ Everything** shows what will be lost, in numbers: how long since the copy, and how many records, log entries and files have changed. It says plainly that **logs since the copy will be lost**.
- The Admin gives a reason and types the BKP number.
- Compass goes into maintenance, shows each step's progress to that Admin, and comes back on hold at the review.
- A copy from a newer Compass is refused, naming the version to deploy first. A copy from an older one is restored and brought up to date.

**Done when**

- A restore on staging returns the data to the copy exactly, checked by row counts and a sample of records, and Compass works afterwards.
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