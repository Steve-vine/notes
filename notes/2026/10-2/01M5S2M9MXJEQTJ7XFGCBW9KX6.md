---
id: 01M5S2M9MXJEQTJ7XFGCBW9KX6
created: 2026-10-25T08:25:27.453243Z
updated: 2026-10-25T15:40:21.041284Z
type: task
title: 'DDQ: "Set up questions" is renamed "Manual question setup"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1294
sprint: ssgnel8
comments:
- id: 01M5SG86C95M343KJVXG5J14KG
  author: Steve Vine
  at: 2026-10-25T12:23:30.953771Z
  text: |-
    Done — merged to main (PR #1314, 003b3a0b).

    Everywhere it showed, the old name now reads **Manual question setup**:
    - the button on the Questions card;
    - both set-up windows (spreadsheet/Word, and email);
    - the empty Questions card ("No questions yet. Use Manual question setup to…");
    - Polaris's tool descriptions.

    Nothing else changed. No deviations.
assignee: steve
label: null
priority: low
task_status: review
---
## What Steve said

"Rename the 'Setup questions' button to 'Manual question setup'"

It's the way a person sets up questions by hand. Polaris's reading of the layout (COM-1280) is the main way.

## Behaviour

Everywhere a person sees the old name, it says **Manual question setup**:
- the button on the DDQ's Questions card;
- the window it opens, for a spreadsheet or Word file (picking sheets and columns);
- the window for an email (splitting it into lines);
- the empty Questions card (my call on the wording): "No questions yet. Use Manual question setup to read them from the spreadsheet / the Word document / to split the email into questions."
- Polaris's tool descriptions that say "as Set up questions does on screen" say "as Manual question setup does on screen".

Nothing else changes: what the button does, who can use it, and the online-DDQ case.

## Implementation notes

- `src/ddq/questions/QuestionsCard.tsx`: the button label at about line 221, and the `EMPTY` texts at lines 97–99.
- `src/ddq/questions/SetUpQuestionsModal.tsx` and `SplitEmailModal.tsx`: the modal `title`s.
- `assistant/tools/ddq.py`: the `ddq_set_up_questions` and `ddq_split_email` descriptions.
- Update the tests that find the button or modal by name.
- Independent: no migration and no OpenAPI change. Tool descriptions aren't in the schema; the route summary "Set Up Questions" in schema.d.ts comes from the handler name and stays.
