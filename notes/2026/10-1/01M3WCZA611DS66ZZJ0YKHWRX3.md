---
id: 01M3WCZA611DS66ZZJ0YKHWRX3
created: 2026-10-01T18:52:36.106967Z
updated: 2026-10-01T20:40:25.534884Z
type: task
title: Frameworks metric alignment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 825
sprint: s0zzctz
comments:
- id: 01M3WK4T5YQ11YKZQM4W1T5C5R
  author: Steve Vine
  at: 2026-10-01T20:40:25.534591Z
  text: |-
    Merged with COM-823: PR #831 (f3f9389) — one change fixes both, because the Frameworks tiles and the Dashboard tiles are the same shared tile. There is no separate PR for this task.

    On Frameworks, the x% now sits at the same height on every tile in a row, and so does "n of m met" — whether the framework's name takes one line or three. The second row of tiles lines up on its own.

    SOC 2's name is also shorter now (COM-826), so its tile no longer runs to five lines.

    To check on staging: Playbook ▸ Frameworks.

    Technical: measured in headless Chromium with the ten frameworks from the screenshot — row one figures at y=189, row two at y=337, every tile.
assignee: steve
label: null
priority: medium
task_status: active
---
As with the  Dashboard metrics, the Framework metrics don't line up very well, with the x% appearing in different places on each tile. Find a way to align them better so they look tidier. Screenshot attached.

![CleanShot 2026-10-01 at 19.49.33@2x.png](attachments/2026/10/01M3WCZA611DS66ZZJ0YKHWRX3/CleanShot-2026-10-01-at-19.49.33@2x.png)
