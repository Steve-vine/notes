---
id: 01M0QZJCV4BN1X1NGMJE843QJ5
created: 2026-08-23T18:54:15.908313Z
updated: 2026-08-23T18:54:20.633474Z
type: task
title: Give-up is checked before the search, so an aged item is closed without ever being looked for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 397
sprint: s5gwx0s
assignee: steve
label:
- bug
priority: high
task_status: active
---
Third fix-forward on COM-390's enrichment, and this one is a sequencing error in COM-396 itself.

`enrich_actors` checks the give-up age **first** and `continue`s, so an item older than `_ACTOR_MAX_AGE` is stamped `unknown` *without a lookup ever being attempted*. When COM-396 widened the lookback to 48h, the four backlog items it was meant to rescue were all >24h old — so they were closed as "no matching entry in the directory audit log for this change" having never been searched under the new window. Their entries were sitting there the whole time (gaps of 16h42m, 11h12m, 2h23m, 2h31m — all well inside 48h).

The claim "no matching entry" must never be made without having looked with the current window.

- [ ] **Search first, then decide.** Attempt the lookup; only if it finds nothing *and* the item is older than the max age, stamp `unknown`. Cost is one extra query per aged item, once, and then it stops for good.
- [ ] The give-up reason stays honest because it now follows an actual search.
- [ ] Test the exact shape that failed: an item well past the give-up age whose audit entry *is* present must be **attributed**, not closed.
- [ ] Test the complement: past the age with genuinely nothing there → one search, stamped `unknown`, and no further searches on later passes.
- [ ] One-off data repair on staging: clear `actor_kind`/`actor_reason` on the items wrongly stamped `unknown` so they get the search they should have had. Not a migration — a repair for a bug, done deliberately and stated.

**Wider lesson**: this is the third defect in this feature found only in production, each one an assumption that looked obviously true when written (audit volume is small; detection is minutes behind; an old item is a lost cause). The enrichment path deserves a harder look at its remaining assumptions rather than another round of patching.

Refs: COM-396 (introduced the ordering), COM-390 (the feature), COM-395 (the query shape).