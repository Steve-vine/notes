---
id: 01M5DAN3ZEWY1FWNKBPH77N259
created: 2026-10-20T18:54:49.838312Z
updated: 2026-10-21T20:16:50.745833Z
type: task
title: A data subject request's Status and Deadline are one card in the side column, each fact shown once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1180
sprint: ss8348q
comments:
- id: 01M5F28QAM6AE3HTZDFDMZARVE
  author: Steve Vine
  at: 2026-10-21T11:06:43.923868Z
  text: |-
    Done — PR #1198, merged 21 Oct 12:06 BST.

    - The side column now has two cards, Request Status and Retention. The Deadline card is gone.
    - Request Status reads top to bottom: the status (with Close request at the top right); Owner and Received; the deadline; the closing checklist with Close another way; and, once closed, the closed details.
    - The countdown appears once ("Due 12 Nov, 09:00 GMT — 9 days left"), amber inside a week and red when overdue. The rule it came from sits under it, then the customer's-deadline note when the request was forwarded.
    - If every part is due at the same moment, the rule shows once and there are no part lines. If parts are due at different times, each keeps its own line.
    - Acknowledge by, the extension and the pauses show as before. Pause, Restart, Extend and Recalculate are small buttons under the deadline, and each still works.
    - The checklist no longer has its own on time / late line. Once closed, the countdown becomes "Was due 12 Nov, 09:00 GMT", and on time or late is said once, in the closed details.
    - Corrections to the status and the deadline sit together at the foot of the card. In the Correct window, Deadline is now inside the Request Status group.
    - The page header's countdown is unchanged.

    My calls:
    - "Different deadlines" means a different due moment, to the minute, since deadlines are now exact. Two parts due the same day at different times get their own lines.
    - If parts share a deadline but come from different rules, each rule is listed once under the countdown.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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