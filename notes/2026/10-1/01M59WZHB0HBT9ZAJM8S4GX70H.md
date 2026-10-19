---
id: 01M59WZHB0HBT9ZAJM8S4GX70H
created: 2026-10-19T10:58:07.840646Z
updated: 2026-10-19T12:24:30.324188Z
type: task
title: The integration tests build their migrated database once per run, not once for every worker
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1115
sprint: sjlj05e
assignee: steve
label:
- follow_up
priority: medium
task_status: active
---
Sprint 77 follow-up, from COM-1089 and COM-1090 (2026-10-19).

## Why

- CI is now limited by g5's CPU, not by how the work is split. One PR's run holds the node at 88–97%. Two PRs at once took 21–24 min against a ~19-minute floor. The way to go faster is less CPU per run.
- Each of the 12 xdist workers starts its own Postgres and replays the whole migration chain from empty, ~300 migrations, to build its template (and, since COM-1090, its checkpoints). On run 39236666536 that was **~45s per worker, paid twelve times**: about 9 CPU-minutes per run, and the first ~45s of every worker's wall time.
- The result is identical every time for a given set of migrations.

## What changes

- The migrated database is built **once per run** (or once per migration set) and every worker starts from it.
- Nothing about what is tested changes.

## Options (technical)

- **Pre-built test image.** On a push to main that touches `app/backend/migrations/`, build `compass/test/postgres-migrated:<hash of migrations/>` (postgres:16 with `template_compass` and the COM-1090 checkpoints already in its data dir) and push it to zot under `compass/test/*` (memory: zot sync re-validates every request). Workers start from it, with no replay. Fall back to today's replay when no image matches the hash, e.g. a PR adding a migration. Cheapest at run time.
- **One shared Postgres per job.** The controller (or the first worker, behind a file lock) builds the template once, and all workers clone from that server. Simpler, but 12 workers then share one Postgres; measure it.
- **pg_dump of the template** built once, restored per worker with `pg_restore -j`. Middle ground.

Measure with the COM-1110 summary: the per-worker `setup` entries at the top of the slowest-30 list should disappear. Record pytest wall time before and after.

**Done when:** no worker replays the full chain in a normal PR run, the before/after pytest time is in the PR, and a PR that adds a migration still works.