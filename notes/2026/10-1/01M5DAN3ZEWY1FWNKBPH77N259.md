---
id: 01M5DAN3ZEWY1FWNKBPH77N259
created: 2026-10-20T18:54:49.838312Z
updated: 2026-10-20T18:54:52.513989Z
type: task
title: A data subject request's Status and Deadline are one card in the side column, each fact shown once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1180
sprint: ss8348q
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve's request while smoke-testing sprint 79.

**What's wrong:** the side column has two cards, Request Status and Deadline, which repeat each other. On a request with one part, the due date appears three times: "Due" in Status's facts, the countdown at the top of Deadline ("Due 12 Nov — 9 days left"), and the part's own line ("Access · Due 12 Nov"). Whether it's on time or late appears again under the closing checklist.

**What it should do:** one card, **Request Status**, in this order:
1. **The status** (and outcome once closed), with **Close request** at the top right, as now.
2. **Owner** and **Received**.
3. **Deadline:** the countdown once ("Due 12 Nov — 9 days left", amber inside a week, red when overdue; "Paused"; "Starts when identity is confirmed"). Under it, the rule it came from ("UK GDPR right of access · 1 calendar month"), and the customer's-deadline note when the request was forwarded.
   - **One line per part only when the parts have different deadlines.** If every part is due the same day, the rule shows once under the countdown and there are no part lines.
   - Acknowledge by, the extension and the pauses, as now.
   - Pause / Restart / Extend / Recalculate as small buttons under the deadline.
4. **Closing checklist** while open, as now, without its own on time / late line, because the countdown already says it. **Close another way** stays under the checklist.
5. **Once closed:** closed when and by whom, on time or late (said once, here; the countdown goes), why late, why closed, the reopen window, and Add a correction / Reopen.
6. Correction notes for status and deadline, together at the foot of the card.

The page header's countdown stays. It's the at-a-glance line at the top of the page, not in the side column.

**Unchanged:** what the deadline buttons do, the closing checklist's items, and the Correct window. Its "Deadline" and "Request Status" areas still exist, but both now point at this one card. Checklist links that went to the Deadline card go to the deadline part of this card.

**Done when:** the side column shows Request Status and Retention only. The due date appears once in the side column for a single-part request. A request with parts due on different days still lists each part. Every button from both cards still works.