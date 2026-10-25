---
id: 01M5S1V3GFPH26CCZZDFJJBZP2
created: 2026-10-25T08:11:41.967407Z
updated: 2026-10-25T08:11:45.083816Z
type: task
title: 'DDQ: a missed question is Polaris''s to sort out — "there''s a question in G5 that''s not listed" — not a hand-typed Add question'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1293
sprint: ssgnel8
assignee: steve
priority: medium
task_status: todo
---
## What Steve said

"I think this should be a Polaris managed feature. Rather than the user enter detail manually they just ask Polaris to do it - 'There seems to be a question in cell g5 that's not listed can you add that'. Polaris then figures out what's going on, was the question missed, added with slightly different wording or deemed irrelevant, and explains why it was missed or adds it as a proper question."

Prompted by: a question added with **Add question** on a spreadsheet or Word DDQ has no place in the client's file, so its answer is never written. It's listed as "Added in Compass — there's no place for it in their file".

## Behaviour

- **The person asks Polaris**, in their own words, pointing at a cell, row or wording ("there's a question in G5 that's not listed"). Polaris reads that part of the client's file and works out which case it is, then says so in plain words:
  - **Missed:** Polaris adds it as a proper question, in the same way as the set-up: its wording, reference, section, guidance, allowed answers, and every field with its cell (Response, evidence list, others). It's checked by the same rules (the cell is in the file, has no formula, isn't merged and isn't used twice). It sits **in the file's order**, not at the end, and starts with Polaris (see COM-1291). Polaris then reads back where it lands.
  - **Already there, worded differently or at another cell:** Polaris names the question it matches ("that's 9b, set up from B16") and changes nothing, unless the person asks it to.
  - **Left out on purpose:** for example a heading, an instruction, the client's own guidance or "office use" column, or a duplicate. Polaris explains why it was left out, and adds it if the person still wants it.
- **Set-up records what it left out and why.** When Polaris sets up a DDQ, it notes each cell it read and decided wasn't a question for us, with a one-line reason ("B3: general guidance for the whole form"). That's kept on the DDQ, so any later conversation, or the built-in agent, can explain it. The set-up summary on screen shows "Left out: n — why" so a person can spot a mistake without asking.
- **On screen, for a spreadsheet or Word DDQ, "Add question" goes.** In its place is a line in the Questions card: "Missed a question? Ask Polaris — tell it where it is in their file."
- **Email and online DDQs keep Add question** (my call). There's no file to place an answer in, and an online system's questions are typed in as they're read.

## Existing questions

- Questions already added by hand to a spreadsheet or Word DDQ are kept as they are.
- Polaris can give one a place on request, while it's unanswered and with Polaris, using the existing layout update.
- Until then, the completed file keeps listing it as having no place.

## My calls (awaiting Steve)

- Email and online DDQs keep the on-screen Add question.
- A question Polaris adds this way counts as part of the set-up: running the set-up again may replace it while it's unanswered and with Polaris, like the questions around it. A hand-added one never is (as now).

## Implementation notes

- Tool: extend `ddq_add_question`, or add `ddq_add_missed_question`, to take the same `QuestionSpec` as `ddq_set_up_layout` (fields with places, guidance, question cell). Validate it through `ddq_layout`'s `_File`/`_Taken` checks against every other question and the cover fields.
- Insert at the file-order position (by sheet order, then row, then column of the question cell) and renumber `position`. Set `from_setup=True`. Hand it to Polaris (`_to_polaris`).
- `ddq_set_up_layout` gains optional `left_out: [{sheet, cell, text, why}]`, stored on the DDQ (a JSON column or a small table; migration), returned by `ddq_get_ddq` / `ddq_list_questions` and shown in the set-up summary. A re-run replaces the list.
- A read Polaris can use to check "is this cell already a question?": `ddq_list_questions` already shows each question's cell; make sure it includes every field's place too, so a cell used as an answer place is recognised.
- Tool descriptions and the Polaris instructions describe the three cases and that it must explain, not silently add.
- Frontend: remove Add question for spreadsheet and Word DDQs; add the "Ask Polaris" line; show the left-out list in the set-up summary.
- On the chain (migration for `left_out`, API change). Do after COM-1291 (same module).
