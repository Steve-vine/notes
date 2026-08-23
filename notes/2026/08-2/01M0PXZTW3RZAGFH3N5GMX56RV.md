---
id: 01M0PXZTW3RZAGFH3N5GMX56RV
created: 2026-08-23T09:07:24.675359Z
updated: 2026-08-23T09:07:29.923696Z
type: task
title: Number the questionnaire — sections, questions, and a line between them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 381
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
A supplier's questionnaire is an undifferentiated run of prompts. Give it structure a person can point at: "we can't answer 1.2 b) until legal comes back" should be a sentence somebody can write.

**A section is a questionnaire.** Vendor forms have no section concept — a form is a flat ordered list of questions — and adding one is a separate job (new table, builder UI, a decision about existing forms). Each *open assessment* is the section, numbered by the order it was opened: "1 - Security review", "2 - Data protection review". Both the session and the combined-review payload order by `opened_at`, so the numbers agree wherever they appear.

- [ ] Sections numbered on the landing page cards, the questionnaire page's own title, and the combined review's headings — the same number for the same questionnaire in all three.
- [ ] Top-level questions numbered `<section>.<n>` in form order: "1.1 - What vulnerability testing do you do?".
- [ ] Conditional follow-ups lettered under their parent: "a) - Which PCI level?", "b) - …". Numbering covers the questions **being asked** (COM-366), so letters are contiguous on screen; an untriggered follow-up has no number because it was never put.
- [ ] Top-level numbers are stable regardless of answers — an unconditional question is always applicable, so 1.3 does not become 1.2 when a follow-up disappears.
- [ ] A horizontal line between numbered questions. A parent and its follow-ups stay in **one block** with no line between them, so a triggered follow-up reads as part of the question that summoned it. No trailing line after the last block.
- [ ] Follow-ups render under their parent rather than at their own form position — the indentation already claims containment and grouping makes it true.
- [ ] The number is part of the field's label, not decoration beside it, so it is in the accessible name and reaches a screen reader.
- [ ] Scope is the Vendor Portal. `QuestionField` is shared with the internal assessment-completion and onboarding screens and is not touched. The builder's dry run (COM-367) numbers as section 1, because it is showing what a supplier meets.
- [ ] Tests: numbering across a parent with several follow-ups (only triggered ones lettered); top-level numbers unmoved as conditions change; section numbers agreeing between the landing page, the form and the review; one line between blocks and none inside one.
