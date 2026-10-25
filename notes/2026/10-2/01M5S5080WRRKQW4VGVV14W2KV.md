---
id: 01M5S5080WRRKQW4VGVV14W2KV
created: 2026-10-25T09:06:56.156379Z
updated: 2026-10-25T15:40:22.225889Z
type: task
title: 'DDQ: Polaris only changes questions that are with Polaris — never one with a person, even the person it acts for'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1296
sprint: ssgnel8
comments:
- id: 01M5SHSTZSF8FAJJFWDFXSYGWA
  author: Steve Vine
  at: 2026-10-25T12:50:37.688972Z
  text: |-
    Done — merged to main (PR #1310, d505046f).

    - Polaris changes a question's answer only while the question is with Polaris. That covers saving, rewording, using a library answer, and changing sources, evidence, classification or fields.
    - A question with a person is refused, even when that person is the one Polaris acts for. Polaris is told: "That question is with Steve Vine. Polaris only changes questions that are with Polaris; ask them to assign it to Polaris first."
    - A person still changes their own question on screen as before.
    - Polaris's instructions and tool descriptions say it moves a person's question to itself only when that person asks for that question, never just to draft it.

    No deviations: every Polaris write already goes through the one holder check, so one rule covers them all.
assignee: steve
label: null
priority: high
task_status: review
---
## What happened

On DDQ-4, Steve asked Polaris to "review all questions again". Polaris drafted new answers on questions 4 and 8 while they were **with Steve**. Compass allowed it because Polaris was acting as Steve, and the COM-1287 rule ("only whoever has it changes its answer") counts Polaris as the person it acts for. Steve noticed that question 4, assigned to him, was now Drafted, and asked: "does that mean that Polaris changed a question assigned to someone else?"

Steve chose the strict rule (option 1).

## Behaviour

- **Polaris changes a question's answer only while the question is with Polaris.** That covers saving or rewording an answer, using a library answer, and changing sources, evidence, classification or other fields. A question with a person, including the person Polaris is acting for, is refused.
- **What Polaris is told when refused:** "That question is with Steve Vine. Polaris only changes questions that are with Polaris; ask them to assign it to Polaris first." Polaris says so to the person and offers to move it.
- **Handing a question to Polaris is the person's choice.** Polaris may move a question to itself only when the person asks for that question, or a list of questions, in the conversation. Moving it takes the question off their Actions, as Assign to Polaris does on screen. The tool description says so, and Polaris never moves a person's question just to draft it.
- **Unchanged:**
  - A person changes their own question on screen as now.
  - Approvers approve or send back whoever has the question.
  - Polaris may still *read* any question, and may *assign* questions when asked.

## Existing questions

DDQ-4's questions 4 and 8 keep the drafts Polaris saved while they were with Steve. They stay with Steve, Drafted, until he confirms or changes them. Nothing else on staging is affected.

## Implementation notes

- `core/ddq_answers.holds()`: when `current_via() == ASSISTANT`, return true only if the holder `is_polaris`. A person-held question is refused even when `held.assignee_id == user.id`. The non-assistant path is unchanged.
- `require_answerable`: give the conflict message above for the assistant path.
- Check every assistant write that edits an answer goes through `require_answerable` / `holds`: `ddq_save_answer`, `ddq_use_library_answer`, the `fields` path (COM-1280), the classification / "Who can this go to?" path (COM-1289), and anything that drafts in bulk.
- Tool descriptions:
  - `ddq_save_answer` and `ddq_assign_questions`: drop "(or by you when they are the person you act for)";
  - `ddq_assign_questions`: add "move a person's question to Polaris only when they ask for it".
- Polaris's instructions: state the rule.
- Tests (integration):
  - the assistant saving on a question with the acting user → 409 with the message;
  - the same user on screen → allowed;
  - the assistant on a Polaris question → allowed;
  - the assistant on another person's question → 409.
- Independent: no migration and no API shape change. The conflict text is not in OpenAPI.
