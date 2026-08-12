---
id: 01KZVCA8WFJKY68J4BZFXQG04W
created: 2026-08-12T16:19:02.671596Z
updated: 2026-08-12T16:19:16.420874Z
type: task
title: Resolve each blast radius once per dashboard evaluation pass
project: 01KX671DATY39VW6GWK3M2T3DN
number: 676
sprint: sdshnf8
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
**Explicitly headless — no screen.** Stated rather than assumed, per the definition of done. Its justification is that it protects the 30s beat everything else in this sprint now depends on.

`included_entities` runs **one recursive-CTE `traverse` per direct member** at depth 3 (`business_applications.py:871-885`), with no caching. The dashboard evaluator is a Celery-beat pass every 30s over every enabled service (`worker.py:278-281`), and `component_states` then computes the same walk a *second* time for each detail read. A board of Business Application tiles multiplies both: a Business Service tile resolves each of its Business Applications, and the same Business Application placed on two boards resolves twice.

**Do**
- Memoise the resolved blast radius per Business Application for the life of one `evaluate_all` pass, and for one detail/board request, so each Business Application resolves once regardless of how many services or Business Services reach it. In-process and request-scoped — **no new table, no stored dependency set**; ADR 0096 §5 is that dependencies are computed on read, and a persisted cache would reintroduce exactly the staleness that decision avoids.
- Check whether the per-member `traverse` can become one batched recursive CTE seeded with all of a Business Application's members. If it can, that is the bigger win and the memo is belt-and-braces; if it can't cleanly, say so in the PR rather than forcing it.

**Measure, don't assert.** Record the before/after of one `evaluate_all` pass over a board of Business Application tiles on staging-like data. A perf task with no number is a claim.

Beware the trap from Sprint 62: **a uniform duration cluster is a timeout, not work** — if every resolution takes suspiciously similar time, look for something retrying before optimising the query.

Correctness must not move: same member set, same de-dup, same retired filter, same evaluated colour. The tests from the earlier tasks are the guard — they should pass untouched.