---
id: 01M127FWQP0A4Y4Z6T8EZYMT4G
created: 2026-08-27T18:25:06.806411Z
updated: 2026-08-29T07:24:53.158079Z
type: task
title: A tier that rises asks for a review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 475
sprint: sd9gmcq
blocked_by:
- 01M127FSZA2R0DQJV54GBWF0DS
comments:
- id: 01M159MSNAN3NJHW02CWBCGVFY
  author: Steve Vine
  at: 2026-08-28T23:00:27.946691Z
  text: |-
    PR #490 open, stacked on COM-474.

    `vendors.risk_tier_raised_on` records the day one of the vendor's engagements last became *more* serious. A review recorded on or after it settles the ask; nothing else clears it.

    A **rise** only. A falling tier raises nothing, and a later fall does not withdraw an earlier rise — what happened is that we asked this supplier to do something more serious, and a fall is not evidence anybody looked. A first tier on an unclassified engagement counts as a rise: that is the moment the seriousness became known.

    `vendor_tier_review_due` is a **declared action source** per ADR 0055, which is what makes it reach the queue, the digest and an unowned vendor by the same route as everything else. It sits *beside* `vendor_review_due` rather than folded into it: one is the cadence coming round, the other is an event, and merging them would either lose the reason or make a scheduled review look like an escalation. Urgency `immediate`; the title carries the reason — "Risk tier rose to critical — review vendor: CloudCo".

    Assessments already on file are untouched, with a test that says so.

    The migration backfills nothing, deliberately: COM-473 gave every engagement a tier, and stamping every vendor here would put a review request against the whole register on day one and teach everyone to ignore the queue.

    One thing this forced: `risk_tier_raised_on` is a mutable vendor column, so the `VENDOR_SNAPSHOT_FIELDS` guard-rail test required it in the revision snapshot. That is the right answer anyway — "when were we asked to look again, and did anyone?" is a question only the history can settle.

    Tests: 5 pure (the rise rule + the source declaration) + 7 integration + 1 frontend.
- id: 01M166GDH6ZA2776RCJQRVYBAJ
  author: Steve Vine
  at: 2026-08-29T07:24:53.157847Z
  text: 'Merged to main as #490 and deployed to staging 2026-08-29 (`staging-20260829-0114`). Migration 0141 backfilled nothing, as designed — no vendor arrived carrying a review request from the baseline being established.'
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
ADR 0060 §6. When an engagement's effective tier goes up, the vendor's review becomes due and the work lands in Actions. Per ADR 0055 this is a **declared action source**, not a bespoke `notify()`.

Assessments already on file are not invalidated, reopened or rewritten — they were answered truthfully against the questionnaire sent at the time, and ADR 0032's snapshot ethos already keeps them readable. What changes is that we are asked to look again.

A falling tier raises nothing.