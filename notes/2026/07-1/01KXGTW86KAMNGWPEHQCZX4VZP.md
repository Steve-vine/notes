---
id: 01KXGTW86KAMNGWPEHQCZX4VZP
created: 2026-07-14T17:30:29.459904747Z
updated: 2026-07-19T21:30:30.178173801Z
type: task
title: Add Review record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 101
sprint: sg31rps
comments:
- id: 01KXGTWNX6496H3K6PG2E4HS2K
  author: Steve Vine
  at: 2026-07-14T17:30:43.49463852Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-29 21:01 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/103 — **stacked on #102** (base = `dev-715` branch; GitHub retargets to `main` once #102 merges).

    Records content reviews as first-class history + a Review action:

    - New **`ContentReview`** model / `content_reviews` table (append-only; reviewer **name + job title snapshotted**, nullable reviewer FK SET NULL). Migration `0027` (also adds optional `users.job_title`).
    - `POST /content/{slug}/reviews` (mark reviewed — appends a review, stamps `review_at`, reschedules `next_review_at` from the type cadence via a shared `_apply_review` helper) + `GET …/reviews`. `add_months()` clamps short months (31 Jan + 1mo → 28 Feb).
    - `User.job_title` in schemas + **Admin → Users** (editable column + create field).
    - Content detail: **"Review date" → "Last reviewed"**, a **Review Record** table, and a **Review…** button + modal (date default today + comment + *Mark as reviewed*).
    - `content_reviews` not added to the activity allowlist (it *is* the review log); reminders engine unchanged (already scans `next_review_at`).

    Green: backend full integration suite **199 passed** (ruff/format/mypy clean) · frontend **124/124** · migration up/down verified.

    Next: DEV-716 (publish-modal next-review date + Mark-as-reviewed) reuses `_apply_review` from this PR.
assignee: steve
task_status: done
priority: medium
---
Contents should have a review record.

Change the field 'Review date' to 'Last Reviewed'

Create a section below Details called Review Record. This should contain a list of all reviews of the content.  Date, Reviewed By (Name, Job Title), Comments.

Add a button next to Publish called 'Review', click it to display a model with a comment box and a date field (defaulted to today), and buttons at the bottom for 'Mark as reviewed' and 'Cancel'.  If 'Mark as reviewed' is clicked, add an entry to the Review record and update both the Last and Next Review dates.

---
*Migrated from Linear [DEV-717](https://linear.app/stevevine/issue/DEV-717/add-review-record) · created 2026-06-29 · completed 2026-06-29*  
*Related to (Linear): DEV-716, DEV-715*