---
id: 01M5SZMKAQJR5S22S6KD2KF9RF
created: 2026-10-25T16:52:26.071629Z
updated: 2026-10-25T18:45:33.374541Z
type: task
title: 'Word questionnaires: each option''s tick boxes are answered from a pick list, and the completed copy ticks the box instead of typing beside it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1314
sprint: ssgnel8
blocked_by:
- 01M5SZF2RTXC1MGF2ZN857ZE6W
comments:
- id: 01M5T63ND47G0ENCEF85Z5WR6Q
  author: Steve Vine
  at: 2026-10-25T18:45:31.172118Z
  text: |-
    Done — PR #1329, merged to main (5f5fcbb9). Migration 0698.

    What changed:
    - Shape A ("☐ Yes ☐ No ☐ N/A" for one option): the option's pick list is the box labels, read from the document automatically. The completed copy ticks the matching box (and clears the others in that cell) and types nothing beside them.
    - Shape B ("☐ ISO 27001 ☐ ISO 9001" in one cell): each option names its own box and is answered Yes (ticked) or No (left empty). Polaris sets this up when it reads the document. A cell can be shared only this way — each option a different box; a box that isn't in the cell, the same box twice, or a whole-cell field alongside them is refused, saying why.
    - A box the client had already ticked in the blank document is listed at set-up so it gets checked.
    - If a box can't be found when the file is written (document changed), the answer is typed in instead and listed on the Completed questionnaire card ("no tick box says 'SOC 2' — written as text").
    - Polaris's read-back shows "☒ ISO 27001" / "☐ ISO 9001", and a box's place reads "Table 1, B1, tick box “ISO 27001”".
    - ADR 0125 amendment added.

    My calls (awaiting Steve):
    1. A question asked only as options — no Response or answer box of its own — now counts as answered once an option is picked, so it can be approved and goes into the completed file. Before this it could never be approved (true for spreadsheets too, since COM-1313).
    2. Answering "No" on a shape-B box clears it, even if the client had pre-ticked it in the blank document; the set-up warning is the prompt to check.
    3. Shape B has no N/A, as the task said (the form has no way to say it).
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Follow-on from COM-1313 (per-option pick lists for spreadsheets), raised at Steve's request, 2026-10-25. **Blocked by COM-1313.** It reuses COM-1313's choices per field.

**Chain:** on the chain. It changes the set-up API: a field can name one tick box in a cell.

## What's wrong

Word questionnaires mark their options with tick boxes. Two shapes are common:

- **A. A Yes/No pair per option.** Each option has its own row or cell with "☐ Yes ☐ No" (or "☐ YES ☐ NO ☐ N/A").
- **B. One box per option in one cell.** "Which do you hold? ☐ ISO 27001 ☐ ISO 9001 ☐ Cyber Essentials": tick all that apply.

Today only a question's main **Response** ticks a box: Compass ticks the box whose label matches the answer (COM-1261). Every other field is written as **text appended to its cell**. On shape A, an option answered "Yes" leaves both boxes empty and types "Yes" beside them. Shape B can't be set up at all: several options share one cell, and a place can't be used twice.

## What people see after the fix

- **Shape A:** each option is a pick list in the question window, listing exactly the labels on its boxes (Yes / No / N/A as the client wrote them), as COM-1313 gives spreadsheets. The completed copy **ticks the matching box** and types nothing.
- **Shape B:** each box is its own option on the question, under the box's label, answered **Yes or No**. Yes ticks that box and No leaves it empty. There is no N/A, because the client's form has no way to say it. The question's Comments still take any detail the client asks for.
- **Polaris** sets this up when it reads the document. It already sees each box and its label (☐/☒ in the questionnaire read-out). For shape A it gives the option the box labels as its choices. For shape B it points each option at its own box in the shared cell.
- If a box can't be found when the file is written (the client changed the document, say), the answer is typed into the cell instead. The Completed questionnaire card lists it ("No tick box says 'Partly' — written as text"), as the Response does today.
- A box the client had already ticked in the blank document is left as it is. Set-up lists it as already answered, so it gets checked.
- **Unchanged:** the main Response's ticking, Word questions without tick boxes, and spreadsheets.

## Notes (technical)

- **Set-up:**
  - `FieldSpec` (`assistant/tools/ddq_layout.py`, `api/v1/ddq_layout.py`) gains an optional `box`: the label of one tick box in the field's cell (shape B).
  - The "place used twice" check becomes cell + box. Two fields may share a cell if each names a different box, and none may take the whole cell as well.
  - Refuse a `box` that isn't in the cell (`ddq_word.checkboxes(tc)` labels) and a `box` on a spreadsheet. A shape-B field's choices are fixed to Yes/No.
- **Model:** `ddq_question_fields.box` (text, nullable). COM-1313 adds `choices`; ideally one migration if built together, otherwise its own.
- **Writing** (`core/ddq_output.py`, `_DocxWriter.field` ~637): today `_append_text(tc, f.text)`.
  - When the cell has check boxes: with `f.box`, tick that box for Yes and leave it for No. Without, tick the box whose label equals the value (`ddq_word.tick`).
  - Fall back to text with a `_listed` note when no box matches, the same as `item()` does for the Response.
- **Reading back:** `ddq_read_completed_placements` shows "☒ ISO 27001" or the ticked label, not the raw value, so Polaris can check it.
- **ADR:** amend ADR 0124 §12 / ADR 0125 §2. Option fields can tick a box, and a field can name one box in a shared cell.
- **Tests** (`test_ddq_word*.py`, `test_ddq_completed*.py`, with a small .docx fixture holding both shapes):
  - set-up with per-field box labels and with shared-cell boxes;
  - a box not in the cell refused;
  - the completed docx ticks the right `w14:checkbox` and writes no text;
  - the no-match fallback is written as text and listed.
