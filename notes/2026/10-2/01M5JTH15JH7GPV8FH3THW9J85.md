---
id: 01M5JTH15JH7GPV8FH3THW9J85
created: 2026-10-22T22:08:25.266152Z
updated: 2026-10-23T18:06:19.665186Z
type: task
title: Library answers fall due for review — 12 months by default, set in DDQ Settings; the owner gets it in Actions, and an out-of-date answer is still suggested but marked "due for review"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1252
sprint: s5uw2fz
blocked_by:
- 01M5JTGWW58DWNMSDR62JS9VK6
comments:
- id: 01M5MA5SFSX8ADAH30DRFCMZCS
  author: Steve Vine
  at: 2026-10-23T12:01:08.601076Z
  text: |-
    Done — merged in #1273 (704e4614, migration 0640_ddq_settings).

    - **DDQ ▸ Settings ▸ Review and reminders** (Manage DDQs), per company: **Library review period** (12 months) and **Remind the owner this many days before a DDQ is due** (7 — used by COM-1265). A save that moves review dates says how many moved.
    - Approving a library answer sets its **Review due** date. From a month before, the owner has "Review Q&A answer: Do you encrypt data at rest?" in Actions; overdue after.
    - On or after its date an answer shows an amber **Due for review** pill — in the library (with a "Due for review" filter), on the entry, and wherever it's suggested. It's still suggested.
    - **Mark reviewed** (owner or anyone who manages DDQs) says it still holds and restarts the clock without a new version; it's in History and the page shows "Last reviewed". The Actions item goes when reviewed, retired, or a new version is approved (which gets its own date).

    My calls:
    - The review date belongs to the version in use, so a newly approved version naturally starts its own clock.
    - "Due for review" (pill and filter) applies on or after the date; the Actions item starts 30 days earlier.
    - Changing the period re-dates every approved answer from when its clock last started, each a History line (as risk assessments do).
    - An answer with no owner reminds everyone who manages DDQs.
    - Ranges: review 1–60 months, reminder 1–90 days. Answers already approved got a date 12 months after approval.
assignee: steve
label:
- feature
priority: medium
task_status: done
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