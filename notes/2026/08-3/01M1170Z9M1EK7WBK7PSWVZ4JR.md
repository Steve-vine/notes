---
id: 01M1170Z9M1EK7WBK7PSWVZ4JR
created: 2026-08-27T08:57:43.476128Z
updated: 2026-08-27T11:48:27.175944Z
type: task
title: CI migrates a populated database, not only a fresh one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 457
sprint: s8cjs5n
comments:
- id: 01M11FVM3N2BB3D3KKTTWFSJT8
  author: Steve Vine
  at: 2026-08-27T11:32:05.364935Z
  text: |-
    Done — PR #439, deployed.

    The test builds a database at the last pre-sprint revision, populates it with the library as it stood there (vendored as a fixture, inserted directly rather than by calling the historic seeder — that code has moved on, and a test needing deleted code has a shelf life), takes it to head and seeds it. The assertion is convergence: an upgraded deployment must land on the same library a fresh install produces.

    That framing was the important choice. The bug class is "the two paths diverge", so asserting a list of specific invariants would only ever catch the divergence somebody had already thought of. Comparing whole maps also means a failure names the control that moved rather than just going red.

    It found two more defects immediately, both already live on staging:

    **Three domain slugs.** 0119 hard-codes each consolidated domain's slug; the seed derives it, and `&` drops out rather than becoming "and". Eleven of fourteen were realigned while COM-423 was written; three were missed because nothing compared the paths. A slug is a URL, so the same domain answered to different addresses depending on how the deployment got there. Fixed in 0125.

    **Forty-two control statements.** COM-424's rewording never reached an existing deployment — the importer is insert-missing-only and backfills only the description, blank-only, and titles were never blank. Twenty of the forty-two still named Moneypenny or deferred to "as defined in the X Policy". Fixed in 0126, applied only where the stored title is still the pre-sprint one so a curator's rewording survives.

    Verified on staging after deploy: head at 0126, zero `-and-` slugs, zero stale titles, zero controls naming a company.

    One deliberate lint exemption: 0126 is a data table of verbatim strings matched against stored values, so E501 and RUF001 are scoped off for that file. Reflowing a statement with implicit concatenation is how a dropped space reaches a WHERE clause, and normalising the source's curly apostrophes would stop the row matching at all.

    The fixture dates. `_ORIGIN` names the oldest supported upgrade origin in one place — move it deliberately and replace the fixture then, rather than accumulating one per revision.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: high
task_status: done
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
