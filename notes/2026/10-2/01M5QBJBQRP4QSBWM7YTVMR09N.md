---
id: 01M5QBJBQRP4QSBWM7YTVMR09N
created: 2026-10-24T16:23:12.376554Z
updated: 2026-10-24T16:23:26.208361Z
type: task
title: 'DDQ: who a question is with is separate from where its answer has got to — "Assigned" stops being a status'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1286
sprint: ssgnel8
assignee: steve
priority: medium
task_status: todo
---
## What Steve saw

Walking DDQ-3: "I don't think that 'Assigned' should be a status. Unanswered, Drafted, Answered, Approved and Not answered could all be true regardless of if the question was assigned to someone or not."

Today assigning a question **replaces** its status with Assigned. Question 5a was Drafted (the assistant wrote it from controls); Steve assigned it to himself to review and it now just says "Assigned" — the fact that a draft exists is hidden. Taking it back recomputes Drafted/Unanswered.

## What changes (behaviour)

- A question's **status** says only where its answer has got to: **Unanswered, Drafted, Answered, Approved, Not answered**.
- **Who it's with** is shown alongside, on its own: "With Steve Vine · due 28 Oct" (overdue in red), or nothing when it's with the owner. Assigning, reassigning, taking back and handing back never change the status.
- **Drafted** = an answer is written but no person has confirmed it (the assistant, the library, carried forward from last time). **Answered** = a person has written or confirmed it — the assignee submitting it, or the owner saving it on the DDQ page. So Answered no longer needs an assignment.
- The questions list gets an **Assigned to** filter (anyone / a person / me / nobody) beside the status filter; the DDQ's progress shows the five statuses, plus "N assigned, M overdue" separately.
- The assignee's page and Actions are unchanged: they see the question, any draft, the note, and submit.
- Rules that hang off "it's with someone" stay, keyed off the open assignment instead of the status: the owner can't change the answer on the DDQ page, mark it Not answered, or approve it while it's with someone — take it back first. An Approved or Not answered question still can't be assigned.

## My calls (awaiting Steve)

- Drafted vs Answered split as above (a person confirming makes it Answered).
- Owner stays locked out of an assigned question's answer until they take it back (one person working an answer at a time).

## Implementation notes

- On the chain: migration + API change. `DdqQuestionStatus.assigned` retired; existing `assigned` rows migrate to `drafted` if they have a current answer, else `unanswered` (same rule as `_back_with_owner`). Postgres can't drop an enum value in place — recreate the type (see the alembic-enum memories).
- `core/ddq_assignments.py`: `assign` stops setting status; `can_answer`/`require_with_them` key off `assignment.is_open`; `take_back`/hand-back stop touching status; `submit` sets Answered.
- `core/ddq_answers.py` `require_answerable`, `core/ddq_review.py` (mark not answered, approve), `api/v1/ddq_answers.py:259`, `api/v1/ddq_review.py:88` counts → `open_assignment` checks; owner save on the DDQ page sets Answered, assistant/library/carry-forward saves set Drafted.
- Question read model gains `assigned_to {name, due_on, overdue}`; list filter `assigned_to`.
- Assistant tools: `ddq.py:66` and `ddq_common.py:93/500/679` status lists drop "assigned"; `ddq_list_questions` gets an `assigned_to` filter; progress text reports assignment separately. ADR 0124 §9 amendment (status set).
- Frontend: status pill + "With X · due" chip on the questions table and question drawer; filter; progress bar; Assignments.test.tsx fixtures.
