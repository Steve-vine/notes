---
id: 01M5Y9F1VWZH5530KGFRSPRSMN
created: 2026-10-27T09:01:07.83625Z
updated: 2026-10-28T18:17:18.31627Z
type: task
title: endoflife.date gets a tile — nothing to set up, but it says when software support dates were last refreshed and lets the daily refresh be switched off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1358
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5Z0EBRDH5V84XSTER538TZJ
  author: Steve Vine
  at: 2026-10-27T15:42:42.445081Z
  text: |-
    Done — PR #1374, merged to main (migration 0712_lifecycle_refreshes).

    - endoflife.date tile, Reference data category.
      - Overview: public and free, used to date the software on technology assets, no account and no key, nothing sent about you.
      - Configure: "There is nothing to set up".
    - Features ▸ Software support dates: the daily 03:35 refresh. Off, it's skipped; the dates already held stay, and new products get none until it's back on. Useful where outbound internet is closed.
    - Status: the last refresh, the last successful refresh, how many products it covered and the last error ("endoflife.date couldn't be reached for 2 products: windows-server, ubuntu."). It needs attention when the last success is more than 3 days old.
    - Each run is now recorded, because Compass kept no last-run record before.

    My call: with the switch off, the tile shows "Not set up", as ADR 0128 §4 says for a tile with nothing to configure.
assignee: steve
label:
- feature
priority: low
task_status: done
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349.

## What people see

- **One tile in the Reference data category: endoflife.date.**
- **Overview:**
  - a public, free list of when software versions lose support;
  - Compass uses it to date software found on technology assets (ADR 0114);
  - no account and no key; Compass sends nothing about you.
- **Configure:** nothing to set up. The tab says so.
- **Features:** **Software support dates**: refresh daily at 03:35.
  - Off, the dates Compass already has stay, and new products get no dates until it's back on.
  - Useful where outbound internet is closed.
- **Status:**
  - the last refresh;
  - how many products it covered;
  - the last error, if the site couldn't be reached.
  - Needs attention when the last successful refresh is more than 3 days old.

## Notes (technical)

- Gate `tasks/software_lifecycle.py` on the switch.
- Record the last run, its count and any error where the summary endpoint can read them. Reuse existing columns if `core/lifecycle.py` already keeps them.

**Chain:** on the chain (API; a migration if the last-run record is new).

**Done when:**
- the tile shows a true last refresh;
- switching it off skips the next run.