---
id: 01KZPY9H26FJ18WZGNHT1VXVT2
created: 2026-08-10T22:57:00.486547Z
updated: 2026-08-11T08:52:41.316555Z
type: task
title: Parallel test modules TRUNCATE each other's data — 57 of them cascade through `system`
project: 01KX671DATY39VW6GWK3M2T3DN
number: 650
sprint: s1rgnyx
comments:
- id: 01KZR0C874PKXZM922EYNEV4DE
  author: Steve Vine
  at: 2026-08-11T08:52:41.316442Z
  text: |-
    PR #590. **The diagnosis in the body above is wrong, and the correction is the interesting part.**

    The cross-module TRUNCATE story cannot happen. `tests/conftest.py::postgres_url` is **module-scoped** and creates a fresh database per test module, on a per-worker container. No module can truncate another module's rows — the 57 `TRUNCATE … system CASCADE` calls each hit their own database. I counted the truncating modules and stopped there, without checking whether they shared a database. That is the second wrong theory for this failure; the first was Docker contention.

    **The actual mechanism**, verified by reproduction:

    `sync._session` cached its sessionmaker in a module global on first use (`sync.py:434-441`) and never looked again. Under `-n 8` a worker process runs many modules in sequence, so the **first** module to reach `_session()` pinned it for every module after it in that process. `GitHubConnector.act`'s one action-time read then queried an earlier module's database, found no `acme/checkout`, and returned "is not registered with ISE" — truthfully, about the wrong database.

    Proved in both directions before fixing: reverting the URL check makes the new test read `['only-in-the-first']` where it expects `[]`.

    **The fix.** `packs.store._session` had this identical bug and fixed it in ISE-503 — its docstring already describes the failure exactly ("a confident answer drawn from another module's data, which is the hardest kind to notice"). So rather than a third copy, both now share one `ConfiguredSessionProvider` in `db.py`. It rebuilds only when the configured URL changes, so a worker still holds one engine and one pool for its lifetime and pays one string comparison per session.

    The four options in the body are all moot: schema-per-worker, loadfile grouping and de-truncating 105 modules were solving a problem that was not there. Isolation was already correct; one cached global was ignoring it.

    **Acceptance, restated and met**: a self-built session follows the configured database rather than the first one it saw, for both providers; the GitHub remediation vertical passes under repeated parallel runs; nothing was serialised, so the parallel speed-up is untouched.

    Worth noting for the sprint's own theme: this is the same shape as the estate findings — a mechanism that was correct (per-module databases) undermined by one component that quietly ignored it. And like the severity override, it failed by staying silent rather than by erroring.
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