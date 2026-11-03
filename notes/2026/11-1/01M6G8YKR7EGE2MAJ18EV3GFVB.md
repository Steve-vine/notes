---
id: 01M6G8YKR7EGE2MAJ18EV3GFVB
created: 2026-11-03T08:38:28.871832Z
updated: 2026-11-03T08:38:32.942645Z
type: task
title: '"In the last 7 days" counts a first load of history as new, and a score with no version reads "(CVSS )"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1538
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03).

## What people see

- **Sources tab:** after the first read, Microsoft says "8,179 in the last 7 days" and NVD "8,000 in the last 7 days". It counts what Compass first saw this week, so the whole 12-month history counts as new.
- **Watch lists:** a list made today over 12 months of items says "Matched 2,479 in the last 7 days · 2,479 in the last 30 days", for the same reason.
- **Item page:** a score with no CVSS version (Palo Alto's) reads "9.4 (CVSS )".

## Fix

- Sources: count items the source published or updated in the last 7 days.
- Watch lists: count matched items published or updated in the last 7 and 30 days.
- The score shows "9.4" with no brackets when the version isn't known.

**Chain:** on the chain if a count's meaning changes in the API description; otherwise independent.

**Done when:** on staging, Sources and Watch lists show week-sized counts after a history load, and Palo Alto's score reads cleanly.