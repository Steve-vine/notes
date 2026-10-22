---
id: 01M5JTH15JH7GPV8FH3THW9J85
created: 2026-10-22T22:08:25.266152Z
updated: 2026-10-22T22:10:38.480596Z
type: task
title: Library answers fall due for review — 12 months by default, set in DDQ Settings; the owner gets it in Actions, and an out-of-date answer is still suggested but marked "due for review"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1252
sprint: s5uw2fz
blocked_by:
- 01M5JTGWW58DWNMSDR62JS9VK6
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

- **DDQ ▸ Settings** (Manage DDQs): **Library review period** (default 12 months).
- Approving an entry sets its **review due** date. The owner gets an Actions item a month before ("Review Q&A answer: Do you encrypt data at rest?"), and it's overdue after. **Mark reviewed**, with no change, restarts the clock; editing goes through approval as normal.
- An out-of-date entry shows an amber "due for review" pill in the library and wherever it's suggested.

## Notes (technical)

- Declare an action source (ADR 0055); no hand-written notify().
- The settings row is per company.

**Done when:** an entry approved 12 months ago is in its owner's Actions and marked in the library; Mark reviewed clears it.