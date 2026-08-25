---
id: 01M0DCXJHCP1E5PMJ7WTQ7X7K7
created: 2026-08-19T16:15:54.924658Z
updated: 2026-08-25T18:43:05.129002Z
type: task
title: Conversations on the internal vendor record, and the badge that says one is waiting
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 292
sprint: sbph5q5
blocked_by:
- 01M0DCX28YDCY8SGR6HX4A3ZF9
assignee: steve
company: null
label:
- feature
priority: medium
task_status: cancelled
---
Follows COM-291. The reviewer's half of the conversation: read and reply on the vendor record, and find out there is something to reply to from the Requests tab.

- [ ] **Conversation card on the internal vendor detail page** (`vendors/detail/cards.tsx`) — the thread oldest-first with author name and timestamp, and a composer beneath it. Rendered only for participants; a non-participant sees no card rather than an empty one.
- [ ] A message from a **deleted account** still renders — the author FK is `SET NULL`, so name it as a departed user rather than dropping the message or printing "null".
- [ ] Opening the card **marks the thread read** (updates `last_read_at`), which is what clears the badge.
- [ ] **Badge on the Requests tab** — next to the vendor name on the parent request row (`RequestGroupTable` / `OnboardingRequests`, the COM-223 grouped list), showing the unread count. It is a **link**: the badge is on Requests but the conversation lives on the vendor record, and a badge that only informs is a dead end.
- [ ] Counts come from the batched payload COM-291 adds — no per-row fetch.
- [ ] **The gap to close or record**: a vendor with unread messages and **no open request** has no row on the Requests tab, so its badge has nowhere to appear. Either surface those threads somewhere on the internal side, or say plainly that internal reviewers only get badged where a request exists.
- [ ] Tests: a participant sees the card, a non-participant does not; the badge shows the count and clears on read; the deleted-author rendering; the badge links through.