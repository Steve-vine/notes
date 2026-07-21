---
id: 01KY0P43QJVX0KCBVF6TRR5S5G
created: 2026-07-20T21:15:15.05893Z
updated: 2026-07-21T17:43:56.230739Z
type: task
title: Assigned to log entry
project: 01KX671DATY39VW6GWK3M2T3DN
number: 174
order: 1.0
sprint: skj7tft
comments:
- id: 01KY1X8VMG60MC7R9JAQV90N4J
  author: Steve Vine
  at: 2026-07-21T08:39:25.072779Z
  text: |-
    PR #155 → main, merged to staging.

    The audit row snapshots the assignee's email on purpose (ISE-105 — a viewer can't read the admin-gated users list, so the id alone tells them nothing), so rather than change what's recorded, the API resolves it to a name at READ time, the way `actor_name` already is (ISE-160). That means your existing timeline entry will read correctly too — no backfill, no migration.

    Falls back to the raw email if the person no longer resolves to a user.
assignee: steve
priority: medium
task_status: done
---
Currently reads
Mon, 20 Jul 2026 | 22:13 - Steve Vine - Assigned to Steve.Vine@moneypenny.co.uk
Should only show full name E.g.
Mon, 20 Jul 2026 | 22:13 - Steve Vine - Assigned to Steve Vine