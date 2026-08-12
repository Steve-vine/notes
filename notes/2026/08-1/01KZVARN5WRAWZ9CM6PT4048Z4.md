---
id: 01KZVARN5WRAWZ9CM6PT4048Z4
created: 2026-08-12T15:51:56.860029Z
updated: 2026-08-12T15:53:15.03907Z
type: memo
title: Build & Deploy Blueprint — trunk-based CI/CD for a new project
project: 01KX671DATY39VW6GWK3M2T3DN
---
Hand this to Claude at the start of a project: *"read this memo — this is how I want the build and deploy process to work."* It is a specification, not a history. Adapt the stack-specific parts; the **hard rules** are the ones that stop it degrading.

## The five ideas it rests on

1. **The PR run is the gate. Nothing else is.** A `pull_request` run checks out `refs/pull/N/merge` — the *merged* state, not the branch tip. So by the time a PR is green, the merge result has been tested. Never run the full suite a second time after merging: it re-tests an identical tree.
2. **On the trunk, run only what is combinatorial.** Two independently-green PRs can break each other in exactly a few ways — schema drift (two migration heads), contract drift (API changed, client types not regenerated). Everything else (lint, types, unit and integration tests) judges *one tree*, and the PR judged that tree. So the trunk run is a small backstop, not a gate, and nothing waits on it.
3. **Deploy is a pointer move, not a build of a branch.** A `staging` ref is fast-forwarded to an already-tested trunk commit. Nothing is ever committed or merged to it.
4. **Fix forward.** A red trunk is fixed by the next commit, never by rolling back the branch model.
5. **Fast feedback is a feature.** If the loop is slow, people batch changes, and batching is what turns iterative work into waterfall. Treat pipeline time as a product requirement.

## Branching

- One issue per branch, branched from the trunk. Dependent work stacks (branch from the parent branch, PR targets the parent).
- PRs merge into the trunk as they go green, in dependency order. After merging a parent, retarget the child's base.
- Delete merged branches.
- **Hard rule:** CI must fire on *every* PR regardless of base branch. If you filter to `base: main`, stacked PRs get no checks at all, and branch protection then blocks the merge you cannot unblock without disabling the gate.

## The three triggers

| trigger | what runs | gates? |
|---|---|---|
| **any PR** | full suite: lint, format, type-check, unit + integration tests, build, secret scan | **yes — the quality gate** |
| **push → trunk** | combined-state backstop only: schema-head check, contract/type drift, generated-artefact freshness. Target ~2 min. | no — reports alongside |
| **push → deploy pointer** | no tests. Build immutable images, deploy, smoke-check. | gated only on secret scan |

Nothing on a PR may build or deploy. Only the pointer push does.

## Job layout

- **Split static checks from the test job.** Lint/format/type-check in their own parallel job returns a style failure in under a minute instead of behind a long test run.
- **Path-filter with job-level skips**, not workflow-level `paths-ignore`. A required check whose job *never runs* sits "Expected" forever and blocks the merge; a job that runs and **skips** satisfies branch protection. Docs-only changes should finish in seconds.
- **Never path-filter the secret scan.** Secrets leak in docs too.
- **Concurrency group per ref.** Cancel superseded *PR* runs; never cancel a deploy run mid-flight.

## Images and deploy

- **Hard rule: immutable tags** — `<branch>-<yyyymmdd-hhmm>` plus the commit SHA. Never `latest`. A mutable layer-cache tag is the only exception, and it is not deployable.
- **Hard rule: schema migrations run in a deploy hook** (e.g. Helm pre-upgrade), never as a container startup side effect. Otherwise N replicas race the same migration.
- Migrations are **append-only**: never edit or delete a merged one. Enforce it in CI by diffing migration files against the trunk on every PR.
- Smoke-check after deploy: internal readiness, then the public URL (which also proves ingress, DNS and certificate issuance). Give every curl a short connect timeout so a stalled TCP connect fails fast and retries instead of hanging the step.

## Keeping the test suite fast — where the time actually goes

Measure before optimising: pull per-job and per-step timings from the CI API, not impressions. The suite is usually one job, and that job is usually one step.

- **Integration tests hit real dependencies** (a real database in a container), never mocks or an in-memory substitute. Run them in parallel workers, each with its own container.
- **Migrate once, then clone.** Build the schema a single time per worker into a template database and `CREATE DATABASE ... TEMPLATE` per test module. Replaying every migration per module is a cost that grows with every migration you ever add. **Watch out:** once modules start from a migrated template, any test asserting *zero-to-head* must be given a virgin database explicitly, or it silently becomes a no-op while still reporting green.
- **Hard rule: every external dependency on a request path must be reachable in tests** — message broker included. If the broker is unreachable, every enqueue burns a connection-retry timeout, and any test claiming to cover the failure mode is vacuous.
- **A uniform cluster of durations is a timeout, not work.** If thirty tests all take ~19s, that is a retry budget, not computation. Run with `--durations` and look for suspicious flatness.
- Prefer per-test isolation that is deterministic under parallel scheduling. A test that passes only because of the partition it landed in will fail on a different one.

## Reading a red pipeline

Check **which step** failed before theorising:
- failure inside dependency install, image pull or network setup → **infrastructure**, not a code signal;
- failure inside lint / type-check / test assertions → **code**.

Network faults produce confidently wrong error messages. Re-run the same commit before diagnosing; a re-run pins the commit, so confirm you are re-running the branch head.

If runners are self-hosted and share a machine with anything else, **serialise** — concurrent suites starve each other's container runtime and produce failures with no code cause.

## Checklist for a new project

1. Trunk + short-lived feature branches; deploy pointer ref created.
2. CI on: every PR, push to trunk, push to pointer — the three triggers above.
3. Branch protection: required checks are the PR jobs; leave *require branches up to date* off unless the trunk moves under you often.
4. Path filters with job-level skips; secret scan unfiltered.
5. Immutable image tags; migrations in a deploy hook; migration append-only check.
6. Record the pipeline decisions as an ADR so the next change to them is deliberate.
