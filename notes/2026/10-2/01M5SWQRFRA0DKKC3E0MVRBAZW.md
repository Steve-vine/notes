---
id: 01M5SWQRFRA0DKKC3E0MVRBAZW
created: 2026-10-25T16:01:47.478516Z
updated: 2026-10-25T17:42:15.107422Z
type: task
title: The question window says why an answer was sent back once, in the "With …" card — and Submit for review sits beside Save answer
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1309
sprint: ssgnel8
assignee: steve
label: null
priority: medium
task_status: active
---
![CleanShot 2026-10-25 at 16.01.18@2x.png](attachments/2026/10/01M5SWQRFRA0DKKC3E0MVRBAZW/CleanShot-2026-10-25-at-16.01.18@2x.png)

Smoke test of sprint 86 round 2 (DDQ-5 on staging, 2026-10-25). Found by Steve.

**Chain:** independent (frontend only, plus one small backend line; no migration, no API change).

## What's wrong

When an approver sends an answer back, the question window shows the reason three times (screenshot):

1. In an orange box beside **Submit for review**: "Sent back: That's wrong".
2. In the **Review** box: "Sent back by Bob Smith, 25 Oct 2026, 3:55 pm: That's wrong".
3. In the **With you** card, as the hand-over note: "Sent back: That's wrong".

**Submit for review** also sits on its own row under **Save answer**, so the two buttons are stacked.

## What people see after the fix

- The reason appears **once**, in the **With …** card. That card already says who has the question, who gave it to them and when it's due. The orange box beside Submit for review goes, and so does the Review box's "Sent back by …" line. With nothing else to say, the Review box doesn't show at all.
- **The same applies when the question is with Polaris.** A sent-back answer that Polaris has gets no new hand-over today, so the reason would show nowhere once 1 and 2 go. In that case the **With Polaris** card shows "Sent back by Bob Smith, 25 Oct, 3:55 pm: That's wrong".
- The reason stays until the answer is submitted again, as it does today.
- **Submit for review** sits on the same row as **Save answer**, to its right. Save answer is the secondary button and Submit for review the primary one.
  - The hint "Drafted. Submit it when it's ready for an approver." goes. The button says it.
  - **My call:** pressing Submit for review with unsaved changes saves them first, then submits. One click, and nothing typed is lost or submitted stale.
- In review, the row shows "In review — locked until an approver approves it or sends it back." in place of both buttons, as today.
- Unchanged: the **Questions** card's "Sent back: …" line under the question's status, the **Assignments** history (it keeps each hand-over's note) and **Review answers**.

## Notes (technical)

- `answers/SubmitAnswer.tsx`:
  - Remove the `note` Alert and the "Drafted…" hint.
  - Keep the in-review line.
  - Move the button into `AnswerForm`'s Save row (`AnswerForm.tsx` ~488: `<Group justify="flex-end">`). Pass `can_submit`/`useSubmitAnswer` in, or render a `SubmitAnswer` button slot there from `AnswerQuestionModal.tsx` (~86), whichever is cleaner.
  - Save-then-submit: chain `submit.mutate()` in the save's `onSuccess` when the form is dirty.
- `review/AnswerReview.tsx` ~51–55: drop the `sent_back_at` branch. The early `return null` already hides the box when nothing is left.
- `assignments/AssignmentPanel.tsx` ~89: the current holder's `note` already carries "Sent back: …" when `reopen_for_send_back` (`core/ddq_assignments.py` ~387) handed it over.
  - For a question with Polaris, or a holder whose assignment was still open, no hand-over happens.
  - Show `question.sent_back_note` (with the answer's `sent_back_by_name` / `sent_back_at`) in the card when the question is Drafted with a `sent_back_note` and the current assignment's note doesn't already start with "Sent back:".
  - Better: have `reopen_for_send_back` set the note to "Sent back by {name}: {comment}" so the card reads the same either way. The Polaris case still needs the fallback line.
- Tests:
  - `SubmitAnswer`/`AnswerReview`/`AnswerQuestionModal` vitest: assert the reason appears once.
  - The Polaris-held case shows it in the With Polaris card.
  - Submit with unsaved edits saves then submits.
