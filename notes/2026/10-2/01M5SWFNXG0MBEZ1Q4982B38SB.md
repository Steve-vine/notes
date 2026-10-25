---
id: 01M5SWFNXG0MBEZ1Q4982B38SB
created: 2026-10-25T15:57:19.152942Z
updated: 2026-10-25T18:31:26.498371Z
type: task
title: 'DDQ: Review answers closes when submitted, saying what it did — not an empty "No answers are waiting for review" window'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1307
sprint: ssgnel8
comments:
- id: 01M5T59QT4Z5JQ318FWW1JF3WR
  author: Steve Vine
  at: 2026-10-25T18:31:21.66628Z
  text: |-
    Done — PR #1324, merged to main (6e0ecef4).

    What changed: in Review answers, Submit now closes the window. What it did is said in a notification ("Review submitted — 12 approved, 2 sent back, 3 added to the library; 4 still to review."). If something wasn't done, the same notification says so: "Decided by someone else first: 5a." and "Not added to the library: <question>: <why>." If Submit is refused (say, a held-back answer chosen for approval), the window stays open with the error, as before. The Review card and the questions list update straight away, as before.

    My call, as written in the task: one notification carrying everything, rather than keeping the window open to list what wasn't done.

    Cause (technical): the window was meant to show a summary after submitting, but the refreshed review list (now empty, with a new saved time) remounted the form and lost it, leaving the empty "No answers are waiting for review" window.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What Steve saw

Smoke-testing sprint 86 on DDQ-5 (COM-1300): "After submitting the Review form I'm left with an empty modal with just the below words, this should just close after submitting."

> Review answers
> No answers are waiting for review.
> 0 of 0 decided

## Behaviour

- **Submit closes the window.** What it did is said in a notification: "12 approved, 2 sent back, 3 added to the library; 4 still to review."
- If something wasn't done, the notification says so as well: questions someone else decided first ("Decided by someone else first: 5a"), and approved answers that couldn't go to the library, with why. (My call: one notification carrying all of it, rather than keeping the window open.)
- The Review card and the questions list show the new statuses straight away, as now.
- If Submit fails (a held-back answer chosen for approval, a reject without a reason), the window stays open with the error, as now.

## Cause

`src/ddq/review/ReviewAnswersModal.tsx`: after a successful submit, the window was meant to show what happened (`done`) with a Close button. But submitting refreshes the review list, which now has no rows and a new `saved_at`. `ReviewForm` is keyed on `saved_at`, so it remounts, the `done` summary is lost, and the empty list shows instead.

## Implementation notes

- In `useSubmitReview`'s `onSuccess` (or the `submit.mutate` call), show `notifications.show({ color: 'teal', message: submittedText(done) … })`, including decided-elsewhere and not-added lines, and call `onClose()`. Remove the in-window `done` view.
- Don't key `ReviewForm` on `saved_at` in a way that remounts mid-submit (key only on first load, or reset picks explicitly when Save returns).
- Tests (`Review.test.tsx`): after Submit, the dialog is gone and the notification text is shown; a failed submit keeps the dialog open with the error.
- Independent: frontend only.