---
id: 01M0PXZTW3RZAGFH3N5GMX56RV
created: 2026-08-23T09:07:24.675359Z
updated: 2026-08-23T09:26:15.23269Z
type: task
title: Number the questionnaire — sections, questions, and a line between them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 381
sprint: sbph5q5
comments:
- id: 01M0PYX6D6YETCX1JWMH0YZ7FA
  author: Steve Vine
  at: 2026-08-23T09:23:26.758143Z
  text: |-
    Done — PR #376 (green, merged), branch feature/com-381-numbered-questionnaire.

    ```
    1 - Security review
      1.1 - What vulnerability testing do you do?
      1.2 - Do you process card data?          ← Yes
        a) - Which PCI level?
        b) - Who is your QSA?
      ──────────────────────────────────────
      1.3 - Who is your DPO?

    2 - Data protection review
      2.1 - Where is the data held?
    ```

    - Section numbers on the landing-page cards, the questionnaire's own title and the combined review's headings, all from the same `opened_at` ordering.
    - Top-level questions `<section>.<n>`; triggered follow-ups `a)`, `b)` under their parent — not "1.2 a)", since the control is already indented under 1.2.
    - Numbers cover what is being asked, so letters are contiguous; top-level numbers never move as conditions come and go.
    - One line between numbered questions, a parent and its follow-ups drawn as a single block, nothing after the last.
    - Grouping made the indentation honest as a side effect: a follow-up now renders under its parent wherever the form positioned it.
    - The number is part of the label, so it reaches a screen reader. `QuestionField` untouched — the internal completion and onboarding screens are unnumbered.

    Two judgement calls worth flagging:

    **The held-button hint keeps the plain name** — "2 questions left in Data protection review", not "…in 2 - Data protection review". The latter is a sentence nobody writes and the card above already carries the number.

    **The combined review is numbered but not divided.** It is a summary read at a different density, and a rule between every block would make a long one heavier rather than clearer. One line to change if you want them there.

    Not done, and deliberately out of scope: real sections *inside* a form. That needs a table, builder UI and a decision about existing forms — a separate task if the questionnaires get long enough to want it.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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
