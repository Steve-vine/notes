---
id: 01KZVCA8WFJKY68J4BZFXQG04W
created: 2026-08-12T16:19:02.671596Z
updated: 2026-08-12T17:48:38.656447Z
type: task
title: Resolve each blast radius once per dashboard evaluation pass
project: 01KX671DATY39VW6GWK3M2T3DN
number: 676
sprint: sdshnf8
blocked_by:
- 01KZVC99FJPV1T3TK3FQPC9XNY
comments:
- id: 01KZVHE9G8PE9X2C2PZQ3CFMGX
  author: Steve Vine
  at: 2026-08-12T17:48:37.256189Z
  text: |-
    Done — PR #627 merged to main as 54c307e. Full CI green. Headless, as flagged.

    The batching question in the brief turned out to be yes, and it was the bigger win. `traverse_many` (estate.py) seeds ONE recursive CTE with every member instead of running `traverse` per member — same walk, same bounds, same cycle guard, each entity returned once at its shallowest depth from any root and naming the root that reached it. That is exactly what the per-member Python loop was computing by hand. Ties resolve by root id so the result is stable rather than dependent on member order. `traverse` itself is untouched, so its nine other callers are unaffected.

    The memo is the second half: pass-scoped, shared across evaluate_all, the list read, and a detail request. In-process only — a persisted dependency cache would reintroduce exactly the staleness ADR 0096 §5 chose derivation to avoid.

    One thing the brief did not anticipate: **the detail endpoint resolved everything twice** — once for the read's member/dependency counts, once for the components board — and that only became visible once the memo existed. Sharing one memo across the request halves a 12s poll.

    Measured by counting statements rather than wall-clock, per the brief's own warning about uniform duration clusters. Three numbers, each pinned by a test using a before_cursor_execute listener so they cannot quietly regress:
    - a 4-member Business Application: 4 walks → 1
    - the same BA reached by two tiles in one pass: 2 → 1
    - one detail read: 2 → 1

    Correctness did not move: the dashboard suites, the Business Application suite (47 tests with impact) and the impact suite all pass untouched, and components still carry their ISE-675 provenance with the memo in play.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
**Explicitly headless — no screen.** Stated rather than assumed, per the definition of done. Its justification is that it protects the 30s beat everything else in this sprint now depends on.

`included_entities` runs **one recursive-CTE `traverse` per direct member** at depth 3 (`business_applications.py:871-885`), with no caching. The dashboard evaluator is a Celery-beat pass every 30s over every enabled service (`worker.py:278-281`), and `component_states` then computes the same walk a *second* time for each detail read. A board of Business Application tiles multiplies both: a Business Service tile resolves each of its Business Applications, and the same Business Application placed on two boards resolves twice.

**Do**
- Memoise the resolved blast radius per Business Application for the life of one `evaluate_all` pass, and for one detail/board request, so each Business Application resolves once regardless of how many services or Business Services reach it. In-process and request-scoped — **no new table, no stored dependency set**; ADR 0096 §5 is that dependencies are computed on read, and a persisted cache would reintroduce exactly the staleness that decision avoids.
- Check whether the per-member `traverse` can become one batched recursive CTE seeded with all of a Business Application's members. If it can, that is the bigger win and the memo is belt-and-braces; if it can't cleanly, say so in the PR rather than forcing it.

**Measure, don't assert.** Record the before/after of one `evaluate_all` pass over a board of Business Application tiles on staging-like data. A perf task with no number is a claim.

Beware the trap from Sprint 62: **a uniform duration cluster is a timeout, not work** — if every resolution takes suspiciously similar time, look for something retrying before optimising the query.

Correctness must not move: same member set, same de-dup, same retired filter, same evaluated colour. The tests from the earlier tasks are the guard — they should pass untouched.