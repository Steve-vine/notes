---
id: 01M0M5X5Q73CYG096SVVGXHKWC
created: 2026-08-22T07:28:02.791149Z
updated: 2026-09-01T13:55:50.353609Z
type: task
title: Rename Portal section to "Portals" and Company Portal to "User Portal"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 343
sprint: s7jknet
comments:
- id: 01M0M8YZC13XNMR5CR51B10SHW
  author: Steve Vine
  at: 2026-08-22T08:21:27.553771Z
  text: |-
    Done — PR #344, merged to main as 874f3a0.

    The sidebar now reads Portals / User Portal.

    Two notes:
    - The item's label was "Compass Portal" rather than "Company Portal" — that's the one the task meant, and it's now "User Portal".
    - The portal's own shell still brands itself "Compass Portal", which is the product name ADR 0047 §7 gave it. This task renamed the door, not the room. Say the word if you want the shell renamed too and I'll raise a task.

    The gate is untouched: the plural section still reads the one Portal grant, and /portal is unchanged.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Rename the **Portal** navigation section to **Portals**, and rename the **Company Portal** menu item within it to **User Portal**.