---
id: 01M23RJ502TWWN5114ZDQQ9RQK
created: 2026-09-09T18:58:22.850711Z
updated: 2026-09-09T19:12:18.702645Z
type: task
title: The Dashboard says which way it is going — a delta on each tile, and a link to the Timeline
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 641
sprint: srtvjyn
blocked_by:
- 01M23RGHGFYCEGX43F5JPJHDE4
assignee: steve
label:
- follow_up
priority: low
task_status: todo
---
Once the snapshots exist the Dashboard can answer "and is that better than last month?" without leaving the page. Each headline tile (compliance, the three tier rings, open gaps, avg maturity) gains a small delta against the snapshot from 30 days earlier — "+4 pts", "−2 gaps" — coloured by direction, with a "View timeline" link in the header.

- The dashboard read gains an optional `previous` block from the nearest snapshot at or before 30 days ago; absent when there is none (a new company), and the tile shows no delta rather than "+0".
- Tile delta is a shared small component so the six tiles agree; the pill/colour rules from the screen conventions apply (green up for compliance and maturity, green *down* for gaps).
- Tests: with and without a previous snapshot.

A follow-up, and droppable: the Timeline page is the deliverable; this is the Dashboard borrowing from it.