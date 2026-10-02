---
id: 01M3WCJMDE317RR392GHJE2DV1
created: 2026-10-01T18:45:40.537829Z
updated: 2026-10-02T08:46:49.098403Z
type: task
title: Dashboard metric alignment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 823
sprint: s0zzctz
comments:
- id: 01M3WK4FPN0JK58P837TW87CQP
  author: Steve Vine
  at: 2026-10-01T20:40:14.80491Z
  text: |-
    Merged: PR #831 (f3f9389).

    The tiles along the top of the Dashboard now line up: every figure in a row sits on one line, and so does the line under it. A label that wraps ("Vendors needing attention") or a line carrying a +/- pill no longer pushes that one tile's figure out of step — the whole row moves together. When the tiles wrap onto a second row, each row lines up on its own.

    This is the shared tile, so the same fix applies on every screen that has them — including Frameworks (COM-825).

    To check on staging: the Dashboard at your usual width, and narrower so the tiles wrap.

    Technical: components/kit/SummaryCards.tsx — the tile's label, figure and sub-line sit on the row's own three tracks (CSS subgrid). Measured in headless Chromium: seven tiles at 1800px, figures at one y on all seven.
assignee: steve
label: null
priority: medium
task_status: done
---
On the dashboard, the metrics boxes along the top don't align their contents, this makes it look a bit messy. Find a way to make the number content line up better. Screenshot attached.

![CleanShot 2026-10-01 at 19.38.09@2x.png](attachments/2026/10/01M3WCJMDE317RR392GHJE2DV1/CleanShot-2026-10-01-at-19.38.09@2x.png)
