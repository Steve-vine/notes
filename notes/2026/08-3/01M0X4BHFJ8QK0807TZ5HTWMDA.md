---
id: 01M0X4BHFJ8QK0807TZ5HTWMDA
created: 2026-08-25T18:54:06.322472Z
updated: 2026-08-25T21:07:04.076972Z
type: task
title: A vendor's Assessments tab says when the vendor is next due to be assessed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 407
sprint: sbph5q5
comments:
- id: 01M0XBZ06MF211E6VC44WVW062
  author: Steve Vine
  at: 2026-08-25T21:07:04.020148Z
  text: |-
    Done — PR #409, merged to main.

    `VendorOut` gains `last_assessed_on` and `next_assessment_due_on`, derived at read time and never stored. The Assessments tab says the standing once at the top: "Last assessed … · next due …" with the same `ReviewDatePill` the vendor header uses, plus "Never assessed" and "No review cadence" for the two cases that aren't dates.

    Both fields are carried because the two null cases mean different things — never assessed is both null, no-cadence is a date with no due date — and the tab says something different for each.

    The aggregate counts `completed` only and folds into the register's existing bulk query rather than one round-trip per vendor.

    Tests: a completed assessment plus a cadence yields the expected date; the most recent of several wins whichever form it was; the register agrees through its bulk path; a closed round doesn't reset the clock — with `completed_at` deliberately stamped on it, so the test proves the filter is on *status* rather than on that column being set; no cadence yields a last-assessed date and a null due date. Frontend covers all three rendered states.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: review
---
On a vendor's Assessments tab, every questionnaire the rules require offers
**Assign**, whether the supplier answered it last month or has never answered
it at all. Nothing on the tab says which. Somebody assigning one is guessing.

Assessing a vendor is **one event**, not one per questionnaire: the round goes
out together and comes back together (COM-365 already sends the whole pending
batch as a single ask). So the tab says it once, at the top — not on every
row.

## What changes for the reader

A single line above **Current**, before any of the questionnaires:

> Last assessed 12 Mar 2026 · **next due 12 Mar 2027**

with the date as a pill coloured by how close it is — green normally, amber
within six weeks, red within two weeks or already past. The same pill the
vendor header uses for its next review, so the colours mean what a reader has
already learnt they mean.

Two cases aren't dates and say so instead:

- **"Never assessed"** — this vendor has never completed a questionnaire. Due
  now.
- **"No review cadence"** — the vendor has no review frequency set, so there
  is nothing to count from. Better said than left blank, because a blank reads
  as "not due".

The date is the most recent completed questionnaire on this vendor, any form,
plus the vendor's review cadence.

Nothing is taken away when the vendor isn't due yet — assigning early is
legitimate (COM-190 made re-running the way to re-assess). The tab now says
where the vendor stands, and the person assigning decides.

An assessment that was closed before the supplier finished doesn't count as an
answer, so it doesn't reset the clock.

## Not the same as the header's next review

The vendor header already carries a next-review pill. That one counts from the
last **review** — us sitting down and judging the vendor. This one counts from
the last **assessment** — the supplier answering. Related, usually close
together, but genuinely different events, and a reader on the Assessments tab
is asking the second question. Worth the comment in the code so the two don't
get merged later.

## The cadence is the vendor's

There is no per-questionnaire cadence in Compass — the only cadence a vendor
has is its review frequency, so that is what this counts from. That suits a
single tab-level date. If questionnaires ever need their own rhythms — a
certification one yearly, a security one quarterly — that is a real thing to
want, a separate piece of work, and the point at which per-row dates would
come back.

## Implementation

Backend — the vendor's assessment standing, derived at read time (ADR 0039
§4), never stored. It belongs on the vendor read rather than on
`RequiredAssessmentOut`, because it is one fact about the vendor and the
required list can be empty while the fact still holds:

- `VendorOut` gains `last_assessed_on: date | None` and
  `next_assessment_due_on: date | None`.
- `vendor_reads`: `max(completed_at)` over this vendor's `completed`
  assessments; `next_assessment_due_on = due.add_months(last_assessed_on,
  vendor.review_frequency_months)` — the same helper `next_review_at` uses, so
  the assessment round and the vendor's own review round on the same
  arithmetic. `None` when either input is missing; the two `None` cases are
  distinguishable because `last_assessed_on` is on the row too.
- The register lists vendors in bulk, so fold the aggregate into the existing
  per-list query rather than adding one per vendor.
- Regenerate `schema.d.ts`.

Frontend — `AssessmentsCard.tsx`: one line under the "Current" header,
`ReviewDatePill` for the date and small badges for the two text cases. No
change to the `unassigned` rows.

The card is shared, so this shows internally as well as in the portal. That is
right — an internal assessor assigning a questionnaire is guessing today too.

Tests: a completed assessment plus a cadence yields the expected date; the
most recent of several wins; a closed-unfinished one doesn't count; no cadence
yields a null date with a non-null last-assessed; never-assessed yields both
null. Frontend: the three rendered states.
