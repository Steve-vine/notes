---
id: 01KY2109VH5FHHYGE5B6NG5JTH
created: 2026-07-21T09:44:39.025391Z
updated: 2026-07-23T18:34:27.490513Z
type: task
title: Incident ID format
project: 01KX671DATY39VW6GWK3M2T3DN
number: 177
sprint: skj7tft
comments:
- id: 01KY2MCAPEVT09HQXF6QZZXTDZ
  author: Steve Vine
  at: 2026-07-21T15:23:16.04653Z
  text: |-
    PR #157 → main, merged to staging.

    Migration 0037 advances the sequence so the next incident is IN-1000. Per your call, existing incidents keep their numbers and render in the new format (IN-0021), leaving a visible gap before IN-1000 — nothing rewritten, so the audit trail's `merged_number` references and any "I21" mentioned in conversation still resolve.

    Two details worth knowing:
    - Padding is a minimum, not a truncation — incident 10000 renders IN-10000.
    - `GREATEST` guards a database whose numbers have already passed 1000; rewinding the sequence would hand out numbers colliding with existing rows. Verified the guard test fails without it.

    The format now lives in one place per side, including a new backend `incident_label()` — the AI names the incident in chat, and if the two drifted you'd read "IN-1042" on screen while the assistant meant a different one.
assignee: steve
priority: medium
task_status: done
---
Change the incident ID format.  At the moment it’s I<nn> E.g. I21
Change it to IN-<nnnn> Start at 1000