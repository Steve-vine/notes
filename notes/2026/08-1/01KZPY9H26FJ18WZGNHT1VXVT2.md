---
id: 01KZPY9H26FJ18WZGNHT1VXVT2
created: 2026-08-10T22:57:00.486547Z
updated: 2026-08-11T08:43:43.45152Z
type: task
title: Parallel test modules TRUNCATE each other's data — 57 of them cascade through `system`
project: 01KX671DATY39VW6GWK3M2T3DN
number: 650
sprint: s1rgnyx
assignee: steve
label:
- tech_debt
priority: high
task_status: active
---
Diagnosed 2026-08-10 while landing Sprint 59 batch 1. `test_github_remediation_vertical.py::test_the_drafted_parameters_actually_open_a_pr` failed on **main** (`4ab7ae8`) and once on a PR, passed on four other runs of the same code, with **zero Docker timeouts** — so not the usual runner contention.

**The mechanism.** CI runs `pytest -n 8 --dist loadscope`: modules are distributed across 8 workers and run **concurrently against one Postgres**. Almost every integration module has an autouse `_clean` fixture that TRUNCATEs the tables it uses — and **57 of them truncate `system CASCADE`**, which cascades through every FK pointing at `system`, including `repo`.

So the failing sequence is:

1. the GitHub module's `_seed` registers `acme/checkout` and **commits**;
2. some other module, on another worker, runs `TRUNCATE … system CASCADE` and wipes `repo` with it;
3. `GitHubConnector.act` opens **its own session** (`connectors/github.py:453` — the one action-time DB read, by design) and finds no repo;
4. it returns `ActionResult(status="failed", detail="acme/checkout is not registered with ISE")`, and the test asserts `executed`.

Nothing is wrong with the code under test. The test is being robbed mid-run by a different module.

**Why it surfaces now.** It is a probability, not a switch: any two modules whose TRUNCATE and read interleave can collide, so it fires occasionally and looks like a flake. Sprint 59 added a module (`test_signal_kinds.py`) that also truncates `system CASCADE`, nudging the odds — but 57 modules is structural, not something one sprint introduced.

**Why it matters more than an occasional red run.** It makes CI's signal untrustworthy in exactly the way that costs the most: a genuine regression and a stolen fixture look identical, so the reflex becomes "re-run it", and a real failure gets re-run until it passes. It also cost time this session — the first occurrence was mistakenly attributed to Docker contention, because it appeared in a run that genuinely had 110 Docker timeouts.

**Options** (a decision, not just a fix):

1. **A schema per worker.** `PYTEST_XDIST_WORKER` selects a Postgres schema (or database) so TRUNCATE can only reach the worker's own rows. Complete isolation; costs migration-per-schema setup time.
2. **`--dist loadfile` plus grouping the truncating modules onto one worker.** Cheap, but only narrows the window rather than closing it.
3. **Stop truncating shared tables.** Per-test unique names and no TRUNCATE at all — the correct end state, and by far the largest change across 105 modules.
4. **Serialise the offenders** with an xdist group marker for every module that truncates `system CASCADE` — pragmatic, and undoes much of the parallel speed-up.

Option 1 is the one that actually makes the guarantee, and it is invisible to test authors once done.

**Acceptance**: two modules that truncate overlapping tables can run concurrently without affecting each other; the GitHub remediation vertical passes under repeated parallel runs; no test depends on being the only writer.