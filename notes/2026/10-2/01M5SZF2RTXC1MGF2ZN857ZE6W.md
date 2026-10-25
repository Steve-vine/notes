---
id: 01M5SZF2RTXC1MGF2ZN857ZE6W
created: 2026-10-25T16:49:25.274327Z
updated: 2026-10-25T18:16:00.324369Z
type: task
title: Each option on a multi-option DDQ question is picked from the client's answers — a Yes / No / N/A list per option, never free text
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1313
sprint: ssgnel8
comments:
- id: 01M5T4DFB97KYZSTKQB4MF51EQ
  author: Steve Vine
  at: 2026-10-25T18:15:55.496938Z
  text: |-
    Done — PR #1325, merged to main (f46c7558). Migration 0697.

    What changed:
    - Each option of a multi-option question can carry the client's own answers (Yes / No / N/A as they wrote them). Polaris gives them when it reads the layout; on a spreadsheet, an option given none picks up its cell's drop-down list automatically.
    - In the question window each such option is a pick list under its own wording; options without a list (a date, a comment) stay text boxes.
    - Only one of the listed answers can be saved, by a person or by Polaris — "yes" is saved as the client's "Yes"; anything else is refused, naming the option and what it allows.
    - A question can't be submitted for review while one of its options is unpicked.
    - The completed file writes the chosen answer in each option's cell. Polaris sees each option's choices when it reads the question.
    - ADR 0125 amendment added.

    My calls (awaiting Steve):
    1. The "every option picked before submit" rule applies to options only — there was no such rule for the main Response, so I didn't add one.
    2. Submitting the whole questionnaire for review still moves every drafted question across without checking options; an approver would see the empty option in Review answers and can send it back.
    3. Manual question setup only ever gives a question a Response and Detail, so it has no options to give choices to — nothing changed there.

    DDQ-6: once this is on staging, Polaris needs to set it up again so its options get their lists.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found setting up DDQ-6 (Company Two, EMIS Supplier Security Questionnaire), 2026-10-25. Steve chose the per-option pick list over a single "select all that apply" list, because the latter loses N/A.

**Chain:** on the chain. It adds a migration (choices per field) and changes the set-up and answer API.

## What's wrong

Many questionnaires ask one question with several options, each answered on its own. DDQ-6 has eight of these:
- 1.1 lists 12 services; 1.2 three locations; 2.1 and 2.2 six certifications each; 3.1 four kinds of data; 4.1 contractors and sub-processors; 6.1 eleven policies; 8.2 five kinds of access.
- Each option is answered Yes, No or N/A in its own cell.

Polaris sets up each option as its own field of the question. Today only a question's main **Response** gets a pick list of the client's answers. Every other field is a free-text box. So "Yeah", "Y" or "yes " can be saved, and is written into the client's cell as typed. Their dropdown and scoring then don't recognise it.

## What people see after the fix

- **In the question window**, each option of a multi-option question is a pick list, under the option's own wording: Yes, No or N/A, exactly as the client's file offers them. Nothing else can be chosen or typed.
- A field with no list of choices (a date, an owner, a comment) stays a text box, as today.
- **Polaris** sets the choices when it reads the layout. They come from the client's own answer list (on DDQ-6, the hidden Dropdowns sheet). It can give each field its own list, since one option may allow N/A and another not.
- **Polaris and people alike** can only save one of the listed answers. Anything else is refused, saying which option and what it allows.
- **Review answers** and the question's Review box show each option's answer as now, e.g. "Hosting Services: Yes".
- **The completed file** writes the chosen answer into each option's cell, word for word as the client lists it.
- An option can be left unpicked while drafting. The question can only be submitted for review once every option has an answer, the same rule as the main Response.
- **Unchanged:** the main Response's pick list, and every question set up without per-option choices.

**DDQ-6:** once this is on staging, Polaris sets DDQ-6 up again so its options get their lists. A new set-up replaces questions that are unanswered and still with Polaris, which is all 96 today.

## Notes (technical)

- **Model and migration:** `ddq_question_fields.choices` (jsonb list, nullable; empty or null means free text). The question's `allowed_responses` stays as the Response field's list. Optionally backfill the response field's `choices` from it so one rule covers both.
- **Set-up:**
  - `assistant/tools/ddq_layout.py` `FieldSpec` and `api/v1/ddq_layout.py` take `choices` per field (max like `MAX_CHOICES`).
  - Allowed on `response` and `other`; refused on `detail` and `evidence_list`.
  - The manual set-up (`ddq_question_schemas.py` ~183/207) gets the same field.
- **Read:** `DdqQuestionFieldOut` gains `choices`. The tools that list questions and fields (`ddq.py` ~545, `ddq_common.py`, `ddq_answering.py`) show each field's choices, so Polaris answers within them.
- **Save:** `core/ddq_answers.py` validates `field_values[field_id]` against that field's `choices` (422 naming the field label and its choices). The same check applies to the Polaris save path (`ddq_answering.py`).
- **Submit:** a question with a field that has choices but no value can't be submitted for review, matching the Response rule.
- **Screen:** `AnswerForm.tsx` ~327 renders `otherFields` as `Textarea`. Render a `Select` (or a SegmentedControl when there are ≤4 choices, matching the Response) for a field with `choices`.
- **Completed file:** `core/ddq_completed.py` already writes `field_values`. No change beyond writing the chosen text.
- **ADR:** amend ADR 0125 §2 (the layout). A field may carry the client's choices.
- **Tests:**
  - set-up with per-field choices;
  - choices refused on detail and evidence fields;
  - a value outside the list refused (person and Polaris);
  - submit blocked with an option unpicked;
  - the completed xlsx writes the choice;
  - vitest: the option renders as a select.
- **Out of scope:** Word questionnaires' tick boxes (☐/☒). A tick-box option could later be a field with choices that writes ☒ or ☐. Raise separately if wanted.
