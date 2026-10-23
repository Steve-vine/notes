---
id: 01M5JTKKXKSYX059VWJ9PPQ3RN
created: 2026-10-22T22:09:50.0032Z
updated: 2026-10-23T18:06:19.826215Z
type: task
title: Keep DDQs on track — progress in the register, the owner reminded in Actions as the due date nears, and overdue questions and DDQs stand out
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1265
sprint: s5uw2fz
blocked_by:
- 01M5JTKEQ4FQBPWT6ABC15JAGW
comments:
- id: 01M5MNSKQMV3R39H8BMC8MJXY8
  author: Steve Vine
  at: 2026-10-23T15:24:12.404318Z
  text: |-
    Done — merged in #1281 (ce18e9f3, no migration).

    - **Requests register:** each DDQ has a progress bar split into approved, answered, assigned and unanswered, with "4 of 12 approved" under it (read out in full to screen readers); a due pill — amber "Due in 5 days" / "Due tomorrow" / "Due today" within a week, red "Overdue" after, none once sent, withdrawn or declined; and a **Mine** switch for the DDQs you own.
    - **Owner's Actions:** "DDQ-7 for Northwind Legal is due in 5 days — 9 questions unanswered", from the lead time in DDQ Settings (7 days by default), "is overdue" after the date; gone once sent, withdrawn or declined.
    - **Overdue assigned questions:** the owner gets "3 assigned questions overdue on DDQ-7"; Details shows it in red with the due pill.
    - **Approvers:** "DDQ-7 is waiting for approval — 4 answers to approve" while it's In review with answers waiting.

    My calls:
    - A DDQ with no owner reminds everyone who manages DDQs.
    - "Unanswered" in the reminder counts only questions with no answer at all (assigned ones aren't included).
    - Not answered counts as done in the bar.
    - The due pill uses a fixed 7 days; the Actions reminder uses the company's lead time.
    - The approval item is emailed straight away like other approvals; the due and overdue items go in the digest.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

- **Requests register:** a progress bar per DDQ (approved / answered / assigned / unanswered), a due-date pill (amber within 7 days, red overdue), and a "Mine" filter.
- **The owner's Actions:** "DDQ-7 for Acme Ltd is due in 5 days — 9 questions unanswered", from a week before the due date (the lead time is in DDQ Settings), and overdue after. It goes away once the DDQ is sent, withdrawn or declined.
- **Assigned questions** past their due date show red on the DDQ, and the owner sees "3 assigned questions overdue".
- **Approvers** get "DDQ-7 is waiting for approval" while it's In review.

## Notes (technical)

- Action sources per ADR 0055; the lead time lives on the per-company settings row from the library review task.

**Done when:** a DDQ due in 5 days is in its owner's Actions with its count, and drops out when sent.