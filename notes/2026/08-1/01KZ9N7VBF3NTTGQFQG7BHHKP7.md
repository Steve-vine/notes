---
id: 01KZ9N7VBF3NTTGQFQG7BHHKP7
created: 2026-08-05T19:08:40.687645Z
updated: 2026-08-05T19:41:54.545117Z
type: task
title: Hide empty sprints toggle
project: 01KY6W9951TW0904DT0GGJVGE7
number: 394
sprint: segj1dz
comments:
- id: 01KZ9PJP58T5RDZ2DFPS1BKBBS
  author: Steve Vine
  at: 2026-08-05T19:32:04.39213Z
  text: |-
    Landed in PR #383 — https://github.com/Steve-vine/notuvia/pull/383 (with NOT-392 and NOT-393).

    An eye toggle right-aligned on the project title row hides every sprint with 0 active tasks. Per-machine preference (the boardMaxCards pattern), off by default.

    Two rules worth knowing: a picked sprint stays visible even when empty (hiding the row a filter runs on would strand the filter with nothing to click to clear it), and row numbers follow the sprint's place in the project rather than its place in the filtered list, so a row keeps its number when empties are hidden. With everything hidden the list says "No sprints with active tasks" rather than going blank.
assignee: steve
priority: medium
task_status: done
---
Add a toggle at the top of the projects section on the same line as the project title but right aligned to hide all sprints that have 0 active tasks.