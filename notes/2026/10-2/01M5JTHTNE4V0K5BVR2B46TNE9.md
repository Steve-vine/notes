---
id: 01M5JTHTNE4V0K5BVR2B46TNE9
created: 2026-10-22T22:08:51.374969Z
updated: 2026-10-22T22:10:41.947304Z
type: task
title: Questions from an email or an online questionnaire — split the pasted text into questions, or add them one at a time as they're read from the client's system
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1256
sprint: s5uw2fz
blocked_by:
- 01M5JTHP41XSMAJNYFY2T11K7J
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

- **Email DDQ ▸ Set up questions:** the pasted email beside a box of questions. **Split by line** turns each non-blank line (or each numbered item) into a question, which you can then tidy: edit, merge, delete, reorder, add a section. Usually the assistant does this instead (it reads the email and adds the questions).
- **Online DDQ:** **Add question** (text, optional reference and section, optional allowed responses). The assistant adds them as it reads each page of the client's system.
- **Any DDQ:** questions can be added by hand at any time while it's in progress.

**Done when:** a pasted 12-question email becomes 12 questions; an online DDQ has questions added one by one with references.