---
id: 01KY20KFHX0TDWBR4FKMS2QR5W
created: 2026-07-21T09:37:44.948223Z
updated: 2026-07-24T12:32:38.64234Z
type: task
title: Incident status pill size
project: 01KX671DATY39VW6GWK3M2T3DN
number: 176
sprint: skj7tft
comments:
- id: 01KY2MC131JKNE492NC3GHMVJ3
  author: Steve Vine
  at: 2026-07-21T15:23:06.209763Z
  text: |-
    PR #156 → main, merged to staging.

    Direct follow-up to ISE-173 — the panel sits beside the title in a nowrap flex row, so a long title squeezed it. The panel now refuses to shrink and its grid columns are fixed (sized to "Alert status" and "Reactivated"), which also lands it in the same place on every incident whether or not it has an alert-status row. The title column takes the slack instead and wraps within itself; only the incident ID stays pinned to one line.

    jsdom has no layout engine so the test can't measure the squash — it renders a deliberately long title and pins the rules that prevent it.
assignee: steve
label: null
priority: medium
task_status: done
---
Make the pills and descriptions on the incident detail page a fixed size so that they don’t get squashed when a long title appears.

![CleanShot 2026-07-21 at 10.36.22.png](attachments/01KY20KFHX0TDWBR4FKMS2QR5W/CleanShot-2026-07-21-at-10.36.22.png)