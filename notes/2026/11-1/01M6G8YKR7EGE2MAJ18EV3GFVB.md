---
id: 01M6G8YKR7EGE2MAJ18EV3GFVB
created: 2026-11-03T08:38:28.871832Z
updated: 2026-11-04T07:45:34.000605Z
type: task
title: '"In the last 7 days" counts a first load of history as new, and a score with no version reads "(CVSS )"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1538
sprint: s6xh9g1
comments:
- id: 01M6GAZMR3BXH6GYRBH504T082
  author: Steve Vine
  at: 2026-11-03T09:13:59.811233Z
  text: |-
    Done: PR #1550 merged (6d78c44e), deployed to staging at 09:06.

    - "In the last 7 days" on Sources, and a watch list's 7- and 30-day counts, now go by the item's own date (the Feed's "Updated"), not when Compass first saw or matched it.
    - A score with no CVSS version shows just the number.

    Pre-UAT (staging, E2E Test Company): **Passed**
    - **Sources:** NCSC 40 total · 2 in the last 7 days; CISA known exploited 1,766 · 11; Cisco 156 · 28; Fortinet 99 · 3; Palo Alto 105 · 2. Microsoft shows 8,179 · 678, because Microsoft revises many CVEs every week.
    - **Watch list:** "Matched 29 in the last 7 days · 1031 in the last 30 days", the same as the Feed's Affects us filtered to 7 and 30 days (29 and 1,031).
    - **Palo Alto PAN-SA-2026-0013's score:** "9.4".

    Screenshots: ~/compass-uat/sprint-102/COM-1538/
assignee: steve
label: null
priority: medium
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