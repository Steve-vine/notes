---
id: 01M6H58EVWNP8MJCEC10FJPRM7
created: 2026-11-03T16:53:11.676601Z
updated: 2026-11-03T18:07:15.527756Z
type: task
title: Typing a CVE id into the feed's search opens the wrong item part-way, and "Security Feed" in the trail leads straight back to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1542
sprint: s6xh9g1
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found by Steve testing sprint 102 on staging (2026-11-03).

## What people see

1. On Security Feed ▸ Feed, Steve types `CVE-2026-109618` into the search box.
2. At `CVE-2026-1096` the list goes from "no matching results" straight to an item's page. That item is **CVE-2026-1096** (a WordPress Google Map plugin XSS), not the CVE being typed (CVE-2026-109618, PHP on Palo Alto products). Both exist on staging.
3. There's no way back to the list. Clicking "Security Feed" in the trail returns to the same item page.

Expected: the item opens only when the typing has finished (or on Enter), it is the item actually typed, and the trail always leads back to the list.

**Cause (technical):**
- `FeedTab.tsx` navigates to `page.jump_to` as soon as the search, debounced by 300 ms, is an exact id. A pause mid-id is enough, and every shorter CVE id is also a real one.
- Probably: the trail's "Security Feed" link keeps the list's address with `?q=CVE-2026-1096`. Going back runs the same search, which jumps again, so it loops. Browser Back probably does the same.

## To decide when fixing

- Jump only on Enter (or a "Go to CVE-…" suggestion row in the list), never on typing alone.
- Arriving back at the list with a jump-worthy search shouldn't jump again, e.g. the jump replaces the search in the address, or doesn't fire on load.

**Done when:** typing CVE-2026-109618 a character at a time never opens CVE-2026-1096; Enter on a full id opens that item; and from that page both "Security Feed" in the trail and Back show the list.

Related: COM-1541 (search matches whole words only).