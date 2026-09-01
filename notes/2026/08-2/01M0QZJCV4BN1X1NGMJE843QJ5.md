---
id: 01M0QZJCV4BN1X1NGMJE843QJ5
created: 2026-08-23T18:54:15.908313Z
updated: 2026-09-01T13:55:50.489062Z
type: task
title: Give-up is checked before the search, so an aged item is closed without ever being looked for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 397
sprint: s5gwx0s
comments:
- id: 01M0R13N449AB7QKRWBYYZ2RN0
  author: Steve Vine
  at: 2026-08-23T19:21:10.019874Z
  text: |-
    Merged (PR #397), deployed, and the staging backlog repaired.

    **Result: 7 user actors / 4 app actors / 0 unknown / 0 still searching.** Every one of the 11 items now names who made the change, and the four that were stuck read as real events:

    - two groups created by `ConnectSyncProvisioning_MPWXAADC_…` — on-prem AD Connect, i.e. not a person, which is exactly the reading COM-391's service badge exists to make effortless
    - a guest account created via B2B invitation: Microsoft records `displayName` = "Microsoft B2B Admin Worker" and `userPrincipalName` = the inviting admin, so the UI shows both halves
    - a membership removal by a named admin, 3h50m before the sync noticed

    The one-off repair was `update unrequested_changes set actor_kind=null, actor_reason=null where status='pending_validation' and actor_kind='unknown' and actor_display is null` — 4 rows, reopening only items closed *without* a name, i.e. exactly those this bug had closed. Deliberate, narrow, and stated rather than quietly done.

    Both new tests were confirmed **red against the old ordering** before committing — a regression test that passes on the broken code is worth nothing, and given this was the third defect in this path I wanted proof rather than confidence.

    **On the wider lesson.** Three production-only defects in one feature, each a plausible-sounding assumption: audit volume is small (it was 23k records), detection is minutes behind (it was 16 hours), an aged item is a lost cause (its entry was sitting there). The common thread is that all three were assumptions about *the tenant's behaviour*, and none of them were checked against the tenant. The unit tests were green throughout because they encoded the same assumptions. Worth remembering when the next integration touches an external system: the tests can only be as right as the model of the other side.
assignee: steve
label:
- bug
priority: high
task_status: done
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