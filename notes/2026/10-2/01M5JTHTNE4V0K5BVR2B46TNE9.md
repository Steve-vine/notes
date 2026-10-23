---
id: 01M5JTHTNE4V0K5BVR2B46TNE9
created: 2026-10-22T22:08:51.374969Z
updated: 2026-10-23T18:06:19.711594Z
type: task
title: Questions from an email or an online questionnaire — split the pasted text into questions, or add them one at a time as they're read from the client's system
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1256
sprint: s5uw2fz
blocked_by:
- 01M5JTHP41XSMAJNYFY2T11K7J
comments:
- id: 01M5KTVF3DPEGJ9EKQJ6TY3WQQ
  author: Steve Vine
  at: 2026-10-23T07:33:21.645456Z
  text: 'Scope change from Steve''s samples (COM-1271, ADR 0124 §7): this task also sets up questions from a **Word document**: pick the table(s) and which column holds the question, response and detail; rows whose cells all repeat one text are headings → sections; YES/NO tick boxes in the response cell become the question''s choices; the client''s prompt already in the notes cell is kept. Done when also: a look-alike of Steve''s Word sample becomes questions with their sections and YES/NO choices.'
- id: 01M5M8ZMDSJGKFKK6Y71XSMYZ9
  author: Steve Vine
  at: 2026-10-23T11:40:18.233248Z
  text: |-
    Done — merged in #1272 (44122415, migration 0635_ddq_question_word).

    - **Word DDQ ▸ Set up questions:** each table in the document is shown as a grid (tick boxes drawn ☐/☒). Pick the tables and which column holds the question, the response and the notes — suggested from the RESPONSE / NOTES row. Heading rows become sections; "1.1⇥Do you…" gives reference 1.1; the YES/NO tick boxes become the choices; the client's "If yes, please provide details" is kept and shown as "Their prompt: …".
    - **Email DDQ ▸ Set up questions:** the pasted email beside a list. **Split by line** makes each numbered item a question with its number as the reference; a line that runs on is joined to it; greeting and sign-off start as "Leave out"; any line can be switched to Question, Section or Leave out before you create them.
    - **Add question** on every DDQ while it's being worked (wording, reference, section, choices) — an online DDQ is built this way. **Start a section here** in the row menu.
    - Re-running any set-up replaces only unanswered questions a set-up made; questions added by hand are never replaced.

    Tried on your Word sample locally (layout only): 30 questions in 4 sections, YES/NO on each.

    My calls:
    - In your sample, heading rows read "INFORMATION SECURITY | RESPONSE | NOTES" — three different cells — so a row is a heading when all its cells match OR when it's unnumbered, has no tick boxes and repeats the column headings.
    - Only modern Word tick boxes are read; old-style form checkboxes and nested tables aren't.
    - "12 months…" isn't split into a reference (a plain number followed by one space stays part of the text).
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

- **Email DDQ ▸ Set up questions:** the pasted email beside a box of questions. **Split by line** turns each non-blank line (or each numbered item) into a question, which you can then tidy: edit, merge, delete, reorder, add a section. Usually the assistant does this instead (it reads the email and adds the questions).
- **Online DDQ:** **Add question** (text, optional reference and section, optional allowed responses). The assistant adds them as it reads each page of the client's system.
- **Any DDQ:** questions can be added by hand at any time while it's in progress.

**Done when:** a pasted 12-question email becomes 12 questions; an online DDQ has questions added one by one with references.