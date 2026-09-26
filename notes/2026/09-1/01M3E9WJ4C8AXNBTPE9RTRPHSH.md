---
id: 01M3E9WJ4C8AXNBTPE9RTRPHSH
created: 2026-09-26T07:29:18.527148Z
updated: 2026-09-26T08:17:45.170038Z
type: task
title: Task tiles are off the top of the screen
project: 01KY6W9951TW0904DT0GGJVGE7
number: 440
sprint: sqsolof
comments:
- id: 01M3ECNB6HJBW6TJFK8ES38GST
  author: Steve Vine
  at: 2026-09-26T08:17:45.169622Z
  text: 'Fixed in PR #443. The card stack is a scroll container with no top padding, so the first card''s box-shadow ring was clipped at the top. 2px top padding on the stack, taken back from the column header, so spacing is unchanged.'
assignee: steve
priority: medium
task_status: active
tech: null
---
Task tiles are slightly off the top of the screen so the border is part missing, screenshot attached.

![CleanShot 2026-09-26 at 08.27.23@2x.png](attachments/2026/09/01M3E9WJ4C8AXNBTPE9RTRPHSH/CleanShot-2026-09-26-at-08.27.23@2x.png)

