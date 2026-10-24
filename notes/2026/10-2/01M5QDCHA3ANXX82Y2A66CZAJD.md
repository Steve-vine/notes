---
id: 01M5QDCHA3ANXX82Y2A66CZAJD
created: 2026-10-24T16:54:58.627648Z
updated: 2026-10-24T19:04:28.286992Z
type: task
title: 'DDQ: every question is always with someone — Polaris (the assistant) or a person; "take it back" goes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1287
sprint: ssgnel8
blocked_by:
- 01M5QBJBQRP4QSBWM7YTVMR09N
assignee: steve
priority: medium
task_status: active
---
## What Steve said

"I think the wording is the issue then, 'take it back' suggests assign it to me rather than unassign it. … let's create a new assignee (not a user) but a reference to the AI Assistant. When questions are created they're assigned to the assistant, and it can answer them, they can then be assigned to users or assigned back to the assistant, questions are never left unassigned. For this to work the AI assistant needs a name, let's call it 'Polaris'."

Builds on COM-1286 (status separate from who it's with). Recorded in the ADR 0125 amendment for COM-1286/1287.

## Behaviour

- **Every question is always with someone:** Polaris or a person. Nothing is ever unassigned. Set-up, and a question added by hand, puts it with **Polaris**.
- **Polaris is the assistant's name.** It isn't a user: it can't sign in, gets no Actions or email, and has no permissions of its own. It works only when someone runs it. Today that's the assistant over the MCP, run by a person who can manage DDQs. Later, the built-in agent will pick up Polaris's questions itself.
- **Only whoever has a question changes its answer** (and marks it Not answered).
  - Polaris's questions are changed only through the assistant.
  - A person's questions are changed only by that person, on the DDQ page or from Actions.
  - The assistant, run by a person, can also work that person's own questions, as them.
  - To work a question yourself, **Assign to me**.
- **Assigning:** anyone who can manage DDQs can move any question that isn't approved or not answered. The choices are **Assign to me**, **Assign to Polaris** and **Assign to someone…**. "Take it back" is gone.
  - **To a person:** with a due date and a note. It reaches them in Actions with an email (as now).
  - **To Polaris:** an optional note (what to use or look at), no due date, no email.
- **A person submits their answer:** it becomes Answered, leaves their Actions, and **stays with them**, so the list shows who answered it. Nobody else changes it without reassigning it.
- **A person hands a question back** (reason required): it goes to whoever assigned it to them. If that person can no longer manage DDQs, it goes to the DDQ's owner, as a fresh assignment due on the DDQ's due date.
- **Review is unchanged.** Any approver approves or sends back regardless of who has the question. A sent-back answer goes to whoever has the question; a person gets it in Actions, Polaris's waits for the assistant.
- **Approved and Not answered questions keep their assignee.** Changing one means assigning it (it's then Drafted or Answered again and needs approving).
- **What it says:** the activity log and the answer's history say "Polaris, run by Steve Vine". The questions list has an **Assigned to** filter with Polaris, me, and each person.

## Existing DDQs

Questions with an open assignment keep it. Every other question goes to Polaris, whatever its status. Approvals stand.

## My calls (awaiting Steve)

- After submitting, the question stays with the person who answered it (it doesn't go back to Polaris), so Polaris never reworks a confirmed answer unasked.
- A hand-back goes to whoever assigned it.
- A Polaris assignment has no due date and no email; the note is its instructions.
- The assistant can work Polaris's questions and the running person's own, never anyone else's.

## Implementation notes

- On the chain, stacked on COM-1286. A question gets a current assignee, always set: either Polaris or a user. Model it as `assignee_kind` (`polaris` | `user`) + nullable `assignee_id` with a check constraint, rather than a fake user row (Polaris must never authenticate, appear in user pickers, or hold permissions).
- `DdqAssignment` keeps the history. A Polaris assignment is a row with `assignee_kind=polaris`, no due date, never an Action. "open" (on someone's Actions) is separate from "current" (who has it): submit closes the Action and leaves the assignee current.
- Migration: an open assignment → current. Otherwise, insert a Polaris assignment per question, assigned by the DDQ's creator, at migration time.
- Edit guard in one place: `can_change_answer(user, question, via_assistant)`. Allowed when the assignee is this user, or when it's Polaris and the request has an assistant token and the user has `ddq.manage`. Replaces `require_answerable`'s assigned branch and COM-1286's `as_assignee` check. 409 says who has it: "It's with Polaris: assign it to yourself to change it".
- `take_back` endpoint and the `ddq_take_back_question` tool are removed. `ddq_assign_questions` takes `to: "polaris" | "me" | user`. The tool descriptions and server instructions introduce Polaris.
- Actor display: "Polaris, run by X" where answers and history record `via_assistant`.
- Frontend: an assignee chip (Polaris with its own icon); the assign menu; the filter; the drawer's edit state follows the guard. Remove the Take back button.
- Tests: set-up assigns to Polaris; the owner is refused on a Polaris question until they assign it to themselves; the assistant can edit a Polaris question but not another person's; hand-back routing; the migration on a populated DB (see migrations-fresh-db-blindspot).
