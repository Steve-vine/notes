---
id: 01M5Y9F1VWZH5530KGFRSPRSMN
created: 2026-10-27T09:01:07.83625Z
updated: 2026-10-27T09:01:07.83625Z
type: task
title: endoflife.date gets a tile — nothing to set up, but it says when software support dates were last refreshed and lets the daily refresh be switched off
label: feature
task_status: todo
priority: low
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1358
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