---
id: 01M23RJ502TWWN5114ZDQQ9RQK
created: 2026-09-09T18:58:22.850711Z
updated: 2026-09-10T08:57:49.459308Z
type: task
title: The Dashboard says which way it is going — a delta on each tile, and a link to the Timeline
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 641
sprint: srtvjyn
blocked_by:
- 01M23RGHGFYCEGX43F5JPJHDE4
comments:
- id: 01M241PM7AV5DYVK6FN4NM4M7F
  author: Steve Vine
  at: 2026-09-09T21:38:06.698197Z
  text: |-
    Done — PR #650 merged to main, full suite green.

    The dashboard read gains an optional `previous` block — compliance, the three tiers, average maturity, open gaps and the date — from the nearest posture snapshot at or before 30 days ago (what the Dashboard actually said then, reconstructed rows included); null when nothing that old exists, and the tiles then show no delta rather than "+0". On the page, one shared Delta pill under each headline tile — "+4 pts", "−0.3", "−2 gaps" — green up for compliance and maturity, green down for gaps, grey when flat; and a "View timeline →" link in the header. schema.d.ts regenerated.

    Tests: the read with nothing old enough (null) and with 10-, 31- and 45-day rows (the 31-day one wins); on the page every tile's wording and sign, the link, and no pills without a previous block.

    Note for smoke testing: on staging the deltas stay blank until there is a snapshot 30+ days old — the by-hand backfill (COM-637) provides that from the revision history.
assignee: steve
label:
- follow_up
priority: low
task_status: done
---
Once the snapshots exist the Dashboard can answer "and is that better than last month?" without leaving the page. Each headline tile (compliance, the three tier rings, open gaps, avg maturity) gains a small delta against the snapshot from 30 days earlier — "+4 pts", "−2 gaps" — coloured by direction, with a "View timeline" link in the header.

- The dashboard read gains an optional `previous` block from the nearest snapshot at or before 30 days ago; absent when there is none (a new company), and the tile shows no delta rather than "+0".
- Tile delta is a shared small component so the six tiles agree; the pill/colour rules from the screen conventions apply (green up for compliance and maturity, green *down* for gaps).
- Tests: with and without a previous snapshot.

A follow-up, and droppable: the Timeline page is the deliverable; this is the Dashboard borrowing from it.