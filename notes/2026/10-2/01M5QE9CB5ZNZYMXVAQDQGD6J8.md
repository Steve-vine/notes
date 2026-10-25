---
id: 01M5QE9CB5ZNZYMXVAQDQGD6J8
created: 2026-10-24T17:10:43.813606Z
updated: 2026-10-25T09:44:13.883643Z
type: task
title: 'DDQ: no question is left blank — "Mark not answered" goes; declining is an answer like any other'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1290
sprint: ssgnel8
blocked_by:
- 01M5QBJBQRP4QSBWM7YTVMR09N
comments:
- id: 01M5QEEKFMVZF58VR4BFG60G0N
  author: Steve Vine
  at: 2026-10-24T17:13:34.964209Z
  text: |-
    **Steve:** "Remove that Mark not answered button completely and the Review section as there's nothing else in it."

    On a DDQ that isn't in review, Mark not answered is the only thing in the answer window's Review box, so the box is an empty heading plus one button. The box already hides itself when it has nothing to show (`AnswerReview` returns null with no lines and no actions). With the button removed, it **won't appear at all while a DDQ is being worked**. It appears only once there's something to review: Approve and Send back for an approver while the DDQ is In review, Add to library after approval, or the held-back warning. Acceptance:
    - The button is removed everywhere: answer window, review list, assistant tool.
    - On a DDQ that isn't In review, the answer window shows **no Review box** for someone who can't approve.
    - The Review box appears only when it has an action or a line to show. Add a test for each.
- id: 01M5QSGB9RWYMXBCVRV518AJD9
  author: Steve Vine
  at: 2026-10-24T20:26:46.454113Z
  text: |-
    **Done: PR #1304, merged to main.** Goes to staging with the rest of sprint 86.

    **What you'll see**
    - **Mark not answered is gone** everywhere: the answer window, the API and Polaris. A refusal or N/A is written as the answer and approved like any other.
    - **The Review box** only appears when it has something in it: Approve or Send back during review, a held-back warning, or Add to library.
    - **Ready to send** means every question is approved.
    - **The Held back card** says each item is reworded to something that can be given (send it back, or ask Polaris to redraft) or released.
    - **Polaris's save tool** tells it to word a refusal for the client, never leave a question blank.

    **Existing questions:** migration 0689 put each question that was marked Not answered back to where its answer is (Unanswered, Answered or Drafted). Its reason is in the questionnaire's History first. There were none on staging. Sent questionnaires are unchanged.

    **Calls awaiting Steve**
    - **Existing reasons** stay in History rather than becoming the answer.
    - **Held-back answers** are reworded or released, never blanked.
assignee: steve
priority: medium
task_status: done
---
## What Steve said

On the Review box's "Mark not answered": "if we didn't want to give the answer that was being asked for we would simply answer the question with that rather than leave it blank so the question would get an answer just not the one they asked for."

## Behaviour

- **"Not answered" stops being a status, and "Mark not answered" goes** from the Review box, the DDQ page and the assistant. The statuses are **Unanswered, Drafted, Answered, Approved** (amends COM-1286's list).
- **Declining is an answer.** "We don't name staff in questionnaires", "Not applicable: we don't use subcontractors" or "Available on request under NDA" is typed (or drafted by Polaris) in the answer box, then reviewed and approved like any other.
- **A DDQ is ready to send when every question is approved** (amends ADR 0124 §10, which also allowed "or marked Not answered").
- **Held back answers.** When an answer can't go to this client, the way forward is a **shareable answer in its place**: the reviewer sends it back with "can't be given — say what we can share", or Polaris drafts one, e.g. "Our BC plan is available to review under NDA". The alternative is an admin releasing it, as now. The Held back tab says so: "Reword it to something that can be given, or release it".
- **Polaris** is told in its instructions: when the honest answer is that we won't or can't say, write that as the answer, in words fit for the client, and never leave a question for blanking.
- **The completed file has no deliberate blanks.** Cells are only blank where something is still unapproved, as a draft file's "not yet answered" list already shows.
- **A row that isn't a question for us** (the client's own "office use" columns, a section heading read as a question) isn't "not answered": it's taken off the questionnaire's questions, which is part of the layout reading (COM-1280).

## Existing questions

Questions marked Not answered go back to **Unanswered**, with their reason kept in the question's history ("Was marked Not answered by Steve Vine: …") so whoever answers it sees why. **Sent DDQs are frozen** and keep showing what was sent, including "left blank" where that happened.

## My calls (awaiting Steve)

- Existing Not answered questions return to Unanswered rather than having their reason turned into the answer. The reason was written for us, not the client.
- Held-back answers are handled by rewording (or release), never by blanking.

## Implementation notes

- On the chain (migration + API), after COM-1286 (both reshape the question-status enum; do them in one enum recreate if they land together).
  - Remove `DdqQuestionStatus.not_answered` and the `not_answered_*` columns, after copying the reason into the history/activity.
  - Remove the route and the assistant tool `ddq_mark_not_answered`.
  - Remove `can_mark_not_answered` from the read models.
- About 22 files reference it, including `core/ddq_review.py` (mark, readiness), `ddq_completed.py`/`ddq_output.py` (blank listing), `ddq_carry.py` (carry-forward of a not-answered question → new/unanswered), `ddq_sent.py` + `ddq_sent_schemas.py` (the frozen sent record must still render old "left blank" entries: keep a read-only value in the snapshot, not the live enum), assistant tools `ddq.py`/`ddq_answering.py`/`ddq_common.py`, and frontend labels, `TrackingMarks`/`tracking.ts`, and `AnswerReview.tsx`.
- Readiness: every question Approved.
- Held back tab copy and the send-back preset.
- Migration test on a populated DB with a not-answered question and a sent DDQ that had one.
