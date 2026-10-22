---
id: 01M5JTKKXKSYX059VWJ9PPQ3RN
created: 2026-10-22T22:09:50.0032Z
updated: 2026-10-22T22:09:50.0032Z
type: task
title: Keep DDQs on track — progress in the register, the owner reminded in Actions as the due date nears, and overdue questions and DDQs stand out
assignee: steve
priority: medium
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1265
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