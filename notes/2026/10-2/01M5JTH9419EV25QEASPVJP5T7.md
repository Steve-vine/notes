---
id: 01M5JTH9419EV25QEASPVJP5T7
created: 2026-10-22T22:08:33.40975Z
updated: 2026-10-23T07:47:18.603204Z
type: task
title: 'Log a DDQ that has come in — who it''s from, why they''re asking, when it''s due, who owns it, and the questionnaire itself: a spreadsheet, the email, or the address of their online system'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1253
sprint: s5uw2fz
blocked_by:
- 01M5JTH15JH7GPV8FH3THW9J85
comments:
- id: 01M5KTVEZMP2SKPJR0BNC90GJV
  author: Steve Vine
  at: 2026-10-23T07:33:21.523075Z
  text: 'Scope change from Steve''s samples (COM-1271, ADR 0124 §6): one of the three is a Word questionnaire, so Format gains **Word document** (.docx upload; .doc refused like .xls). The format enum ships with spreadsheet · document · email · online.'
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

**DDQ ▸ Requests:** `DDQ-7`, requester, kind, format, status, owner, due, progress. Filters: status, kind, owner, overdue. **New DDQ** (Manage DDQs).

**New DDQ:**
- **Requester:** organisation, contact name and email.
- **Kind:** Onboarding · Recertification · Other.
- **Due date**, **owner** (a person with Manage DDQs, defaults to you), an optional reference (theirs).
- **Format:** **Spreadsheet** (upload `.xlsx` / `.csv`; `.xls` is refused with "save it as .xlsx first"; macros, images and charts are reported as "won't survive in the completed copy") · **Email** (paste the text; attach any files that came with it) · **Online** (the address of their system, and any notes).
- Other files can be attached at any time (their covering letter, their own policy).

Created as **Received**. It becomes **In progress** at the first answer. **Withdraw** or **Decline** (with a reason) are available until it's sent; it's kept either way.

The DDQ page shows the details card, the questionnaire, Questions (once they exist), and History.

## Notes (technical)

- Tables: ddq (company, number from one sequence, requester fields, kind, format, status, owner, due, portal url), ddq_file (original kept unchanged; storage as evidence files).
- Status enum ships with every state now (received, in_progress, in_review, sent, withdrawn, declined) so later tasks don't alter it.

**Done when:** a manager logs DDQ-1 with a spreadsheet and DDQ-2 from an email; withdrawing DDQ-2 keeps it in the register with its reason.