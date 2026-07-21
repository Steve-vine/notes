---
id: 01KY0NAVVTQN285Q7D1EWX2SXB
created: 2026-07-20T21:01:27.802074Z
updated: 2026-07-21T16:39:28.519595Z
type: task
title: Incident Detail Pills
project: 01KX671DATY39VW6GWK3M2T3DN
number: 173
order: -2.0
sprint: skj7tft
comments:
- id: 01KY1X8NM9BXX672SYR3SMNDZA
  author: Steve Vine
  at: 2026-07-21T08:39:18.921776Z
  text: |-
    PR #154 → main, merged to staging.

    All four pills now sit top-right, one labelled row each, in the order you gave (Status / Severity / Source / Alert status). Laid out as a two-column grid with the labels right-aligned against the pills, so the columns line up across rows instead of going ragged. Severity and Source came out of the title line to get there.

    Alert status is omitted rather than blanked when the incident has no signal behind it (a manual incident) — say if you'd rather see the row with a dash.
assignee: steve
priority: medium
task_status: done
---
On the incident detail page, move the 4 pills to the right hand side of the screen, aligned one above the other with descriptions.
E.g.
Status          (New)
Severity       (High)
Source         (Promoted)
Alert Status  (Firing)