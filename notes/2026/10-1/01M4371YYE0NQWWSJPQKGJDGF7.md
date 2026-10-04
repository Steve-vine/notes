---
id: 01M4371YYE0NQWWSJPQKGJDGF7
created: 2026-10-04T10:23:50.222564Z
updated: 2026-10-04T11:09:02.963247Z
type: task
title: Sizing issue
project: 01KY6W9951TW0904DT0GGJVGE7
number: 504
sprint: sx287fa
comments:
- id: 01M439MQ2G1WWYHK89S0DT53RD
  author: Steve Vine
  at: 2026-10-04T11:09:01.90267Z
  text: |-
    Done on branch brief-504-crosssync-polish (commit 33d91f3) — PR #490, which carries all six sprint tasks (NOT-504..509): https://github.com/Steve-vine/notuvia/pull/490

    Cause: the view chose its layout from the window's width (a media query), but the space it actually gets is what the sidebar and the properties pane leave. In a shrunken window the name column was squeezed to nothing, and the status and action icons were drawn on top of the name and "added on" text; the header buttons sat on the heading for the same reason. Reproduced exactly as in the screenshot at a 330px panel.

    Fix: the layout now answers to the panel's own width (a container query).
    - The Sync all / Add file buttons wrap under the heading instead of squeezing it.
    - Below 600px a row's status and action icons move to a line under the name and path.
    - Below 400px the action icons take a line of their own.
    - "added on …" truncates with an ellipsis rather than spilling out.

    Tested: the real view rendered in headless Chrome at panel widths 240, 300, 330, 380, 410, 460, 520, 590, 610, 650, 760 and 900px, with a check that no two parts of a row or the header intersect and that nothing scrolls sideways — clean at every width (the same check reports the overlap on the old CSS). Also checked with the add form open, with a filter on, and in the light theme. Not run in the Tauri app, so WKWebView itself is unverified; container queries need Safari 16 / macOS 13 or later.
assignee: steve
priority: medium
task_status: review
tech: null
---
When shrinking the window down the CrossSync tab contents start to overlap each other, screenshot attached.

![CleanShot 2026-10-04 at 11.24.02@2x.png](attachments/2026/10/01M4371YYE0NQWWSJPQKGJDGF7/CleanShot-2026-10-04-at-11.24.02@2x.png)

