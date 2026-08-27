---
id: 01M1170Z9M1EK7WBK7PSWVZ4JR
created: 2026-08-27T08:57:43.476128Z
updated: 2026-08-27T08:57:43.476128Z
type: task
title: CI migrates a populated database, not only a fresh one
company: moneypenny
assignee: steve
label: improvement
priority: high
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 457
---
Sprint 42's staging deploy failed twice on defects CI could not see, because **CI only ever migrates a fresh database**. Every data-transforming migration in the sprint is guarded by some form of:

```python
if not conn.scalar(sa.select(sa.func.count()).select_from(_controls)):
    return  # migrations run before the seed; nothing to transform
```

On a fresh database that branch returns immediately, so the transformation is never executed by any test. The path that runs on a real deployment is the one nobody tests.

Three defects reached staging this way (COM-456): a VARCHAR bound into an enum column, a soft-deleted control squatting on a ref, and a renumbering that disagreed with the regenerated library on 62 of 256 controls. Each was found in minutes once a populated database was available, and none was findable without one.

## What to build

An integration test that exercises the **upgrade** path:

1. `alembic upgrade <the revision before the sprint>` against a scratch database.
2. Seed the library **as it was at that revision** — which means vendoring the historic `controls.csv` (and the domain list it implies) as a test fixture, since the current CSV describes the post-migration shape.
3. `alembic upgrade head`, then run the seed.
4. Assert the result equals what a fresh install produces: same live control set, same refs, no orphan mappings, no control without a description.

The last assertion is the valuable one. The bug class is "the two paths diverge", so the test should be "the two paths converge" rather than a list of specific invariants.

## Cost worth naming

The fixture is a snapshot of a historic library, so it dates. One option is to pin it to a single "oldest supported upgrade origin" and move that deliberately, rather than keeping a fixture per revision.
