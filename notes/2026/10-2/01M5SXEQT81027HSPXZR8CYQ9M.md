---
id: 01M5SXEQT81027HSPXZR8CYQ9M
created: 2026-10-25T16:14:16.904114Z
updated: 2026-10-25T16:14:20.918567Z
type: task
title: An answer Polaris drafted with no source gets the "no source in Compass" warning too, on the question window and in Review answers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1310
sprint: ssgnel8
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Smoke test of sprint 86 round 2 (DDQ-5 on staging, 2026-10-25). Raised at Steve's request.

**Chain:** independent (no migration, no API shape change; one backend rule and one screen line).

## What's wrong

An approver is warned "From Bob Smith — no source in Compass" when a **person** wrote an answer without citing anything in Compass. That tells them the person's word is the only basis.

An answer **Polaris** drafted with no source gets no warning at all. It looks just like one built from a policy or control. On DDQ-5, 17 answers Polaris saved (the made-up test answers) cite nothing, and both the question window's Review box and **Review answers** showed them without a warning.

A Polaris answer with no source is the riskiest kind. Nobody vouched for it and nothing in Compass backs it.

## What people see after the fix

- **Review answers:** a row whose answer Polaris drafted with no source shows "From Polaris — no source in Compass" in the row's warnings, as a person's does today. It can still be approved. The warning is a prompt to check, not a block.
- **The question window's Review box** shows the same line to anyone who can approve or send it back.
- Cover-field questions are still exempt, as today ("Company Name" has no source to cite).
- An answer repeated from last time keeps its own "Last time we said this…" line in place of this one, as today.
- Unchanged: a person's sourceless answer still reads "From <name> — no source in Compass".

## Notes (technical)

- `api/v1/ddq_review_answers.py` ~193: drop `and not answer.via_assistant`. Word it with `ASSISTANT_NAME` when `answer.via_assistant`, else the drafter's name.
- `frontend/src/ddq/review/AnswerReview.tsx` ~43: drop `&& !answer.via_assistant`. Use "Polaris" when `answer.via_assistant`, else `drafted_by_name`.
- Tests:
  - `test_ddq_review_answers.py`: the Polaris-drafted row in `test_polaris_drafts_are_not_offered_to_the_library_and_cover_fields_are_approved` has no source. It now carries the warning, so assert it.
  - `AnswerReview` vitest: a sourceless Polaris answer shows the line.
- Out of scope, for Steve to decide separately: whether Polaris should be allowed to save a sourceless answer at all. Today it can (ddq_save_answer with a classification and no sources), which is how the DDQ-5 test answers went in.
