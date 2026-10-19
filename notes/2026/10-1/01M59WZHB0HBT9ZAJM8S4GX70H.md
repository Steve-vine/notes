---
id: 01M59WZHB0HBT9ZAJM8S4GX70H
created: 2026-10-19T10:58:07.840646Z
updated: 2026-10-19T18:09:32.151216Z
type: task
title: The integration tests build their migrated database once per run, not once for every worker
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1115
sprint: sjlj05e
comments:
- id: 01M5A65TSJVH2Y52FGTRT8DZEE
  author: Steve Vine
  at: 2026-10-19T13:38:51.314136Z
  text: |-
    Merged in PR #1106 (2026-10-19). Chose the "one shared Postgres per job" option.
    - backend-test starts one Postgres (durability off, max_connections 600, 1 GB shm) and exports COMPASS_TEST_POSTGRES_URL.
    - conftest's pg_server then has the first worker build template_compass and the 15 COM-1090 checkpoints under an flock, under a _building name that is renamed when complete, so a half-built template is never used. Every worker clones from that one server.
    - Locally, with the variable unset, nothing changes.
    - Redis stays per worker.
    - Checked first that nothing in the tests or app uses server-wide Postgres state.

    Measured with the PR alone:
    - 1 migration replay per run instead of 12.
    - Each worker's first setup takes ~12s, against ~45s.
    - pytest 10m52s against 11m06s: wall clock within noise, since the twelve builds used to overlap. The saving is ~5 CPU-min per run, which counts when PRs share g5.
    - All 3,008 passed, including a run with three PRs in flight.

    A PR adding a migration works by construction: templates are built from the PR's own tree.
assignee: steve
label:
- follow_up
priority: medium
task_status: done
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