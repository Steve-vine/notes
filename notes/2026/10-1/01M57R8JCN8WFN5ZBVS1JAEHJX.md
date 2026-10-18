---
id: 01M57R8JCN8WFN5ZBVS1JAEHJX
created: 2026-10-18T14:57:12.085395Z
updated: 2026-10-18T14:57:40.754461Z
type: task
title: CI's two slow test jobs run split across several runners at once, so a PR's wait drops from ~17 minutes to under 10
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1089
sprint: sjlj05e
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 77, CI / Build optimisation. Raised 2026-10-18 from Steve's question "why are sprints taking longer?". Start after sprint 76 is on staging, so the pipeline doesn't change under a running sprint.

## Why

Every PR waits for its two slowest CI jobs, and both have roughly doubled in five weeks as the suite grew:

| | mid-Sept | now (PR #1072) |
|---|---|---|
| backend-test | ~9 min | 18 min, of which **pytest 16.7 min** |
| frontend | ~8 min | 17.5 min, of which **Vitest 13.6 min** |
| backend tests | 1,897 | 3,318 |
| frontend tests | 1,246 | 2,227 |

In a module sprint the tasks queue end to end, so this wait is paid about 19 times per sprint.

## What changes

- The **backend integration tests** run as several parallel jobs (start with 3) instead of one. Each job takes a balanced share, split by measured durations rather than by file count.
- The **frontend tests** run as parallel shards (start with 3). Lint, type-check, Prettier and build run as their own job alongside, not before, the tests.
- A PR still shows one **backend-test** and one **frontend** result. They are small jobs that pass only when every shard passed, so the gate reads exactly as today.
- Nothing about what is tested changes. Every test still runs on every PR (ADR 0041: the PR is the only gate).

## Why COM-332's "not sharded" no longer holds

The comment above `backend-test` in `ci.yml` rejected sharding for two reasons:

- **Fixed setup cost.** It was ~46s for `uv sync` plus a pre-pull of up to 6m48s, comparable to the ~3-minute suite. It is now **about a minute**, against a 16.7-minute suite.
- **The g5 limit `fs.inotify.max_user_instances` was 128**, which starved dind. It now reads **1024**.

Update that comment with the new measurements as part of this task.

## Notes (technical)

- Backend:
  - a matrix of N jobs, each `pytest -m integration -n 6 --dist loadscope` over its slice;
  - split with `pytest-split` (`--splits N --group i`) using a committed `.test_durations`, refreshed by a periodic job or by hand;
  - or, if adding a dependency is unwelcome, a deterministic split by module, balanced by the last measured `--durations=0`;
  - keep `uv` cache and image pre-pull per shard.
- Frontend: `vitest run --shard=i/N` in a matrix; static checks in a sibling job.
- Aggregator jobs named `backend-test` and `frontend` (`needs:` the shards, `if: always()`, fail unless every shard succeeded). `auto-rerun.yml` must still match failures inside shards.
- **Runner capacity.** compass-runners max is 6. Three plus three shards per PR means one PR at a time saturates the fleet. Measure both "one PR alone" and "two PRs together" and pick N so two concurrent PRs still finish faster than today. Raising the scale-set maximum is an option if g5 CPU allows: check `kubectl top nodes` during a run, as g5 has 16 cores (memory: g5 local work competes with CI).
- Record before/after wall times in the PR.

**Done when:** a typical PR's slowest required check finishes in under 10 minutes when run alone, and two concurrent PRs each finish faster than today's ~17 minutes. Gate semantics unchanged; the `ci.yml` comment updated.