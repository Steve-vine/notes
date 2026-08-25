---
id: 01M0X4BHFJ8QK0807TZ5HTWMDA
created: 2026-08-25T18:54:06.322472Z
updated: 2026-08-25T18:54:10.432959Z
type: task
title: An assessment waiting to be assigned says when it's next due
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 407
sprint: sbph5q5
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: todo
---
On a vendor's Assessments tab, every questionnaire the rules require offers
**Assign**, whether the supplier answered it last month or has never answered
it at all. Nothing on the row says which. Somebody assigning one is guessing.

## What changes for the reader

Each row in **Current** that offers Assign gains a date pill beside the
"Required" badge, saying when that questionnaire is next due:

- **a date, coloured by how close it is** — green normally, amber within six
  weeks, red within two weeks or already past. The same pill the vendor header
  already uses for its next review, so the colours mean what a reader has
  already learnt they mean.
- **"Never assessed"** where this vendor has never completed that
  questionnaire. Due now, and it is not a date.
- **"No review cadence"** where the vendor has no review frequency set, so
  there is nothing to count from. Better said than left blank, because a blank
  reads as "not due".

The date is the last completed answer plus the vendor's review cadence.

Assign is **not** taken away when a questionnaire isn't due yet — re-running
one early is legitimate (COM-190 made re-running the way to re-assess). The
row now says what it costs the supplier, and the person assigning decides.

Two things it deliberately doesn't do. A questionnaire already in flight —
pending or open — gets no pill; it is being answered now, and "due" is not a
question about it. And an assessment that was closed before the supplier
finished doesn't count as an answer, so it doesn't reset the clock.

## The cadence is the vendor's

There is no per-questionnaire cadence in Compass — the only cadence a vendor
has is its review frequency, so that is what this counts from, and every
questionnaire on a vendor falls due on the same rhythm. If a certification
questionnaire should come round yearly while a security one comes round
quarterly, that is a real thing to want and a separate piece of work.

## Implementation

Backend — `RequiredAssessmentOut` gains `last_completed_on: date | None` and
`next_due_on: date | None`, both derived at read time (ADR 0039 §4), never
stored:

- In `list_required_assessments` (`api/v1/vendor_assessments.py`), alongside
  the existing `outstanding` and `answered` sets, select
  `max(completed_at)` grouped by `form_id` for this vendor's `completed`
  assessments.
- `next_due_on = due.add_months(last_completed_on, vendor.review_frequency_months)`
  — the same helper `vendor_reads.next_review_at` uses, so a questionnaire and
  the vendor's own review round on the same arithmetic. `None` when either
  input is missing; the two `None` cases are distinguishable because
  `last_completed_on` is also on the row.
- The schema docstring already explains why this join belongs server-side —
  extend the same reasoning rather than deriving the date in the browser.
- Regenerate `schema.d.ts`.

Frontend — `AssessmentsCard.tsx`, the `unassigned.map` rows: render
`<ReviewDatePill nextReviewAt={row.next_due_on} />` after the Required badge
when there is a date, `Never assessed` when `last_completed_on` is null, and
`No review cadence` when it isn't but `next_due_on` is. `ReviewDatePill` takes
a `string | null` and renders a dash for null, so the two text cases want their
own small badges rather than passing null into it.

The card is shared, so this shows internally as well as in the portal. That is
right — an internal assessor assigning a questionnaire is guessing today too.

Tests: a completed assessment plus a cadence yields the expected date; a
closed-unfinished one doesn't; no cadence yields a null date with a
non-null last-completed; never-assessed yields both null. Frontend: the three
rendered states.
