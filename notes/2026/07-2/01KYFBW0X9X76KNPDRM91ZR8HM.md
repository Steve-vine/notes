---
id: 01KYFBW0X9X76KNPDRM91ZR8HM
created: 2026-07-26T14:04:40.745435Z
updated: 2026-07-30T13:00:44.501651Z
type: task
title: Title wrap
project: 01KY6W9951TW0904DT0GGJVGE7
number: 374
sprint: segj1dz
comments:
- id: 01KYFCABMPGGEWSBM6GNQAD9T7
  author: Steve Vine
  at: 2026-07-26T14:12:30.486217Z
  text: |-
    Fix up in PR #363: https://github.com/Steve-vine/notuvia/pull/363

    Cause: the edit-mode (Live/MD) title row was a single-line input — Read mode's h1 already wrapped. It's now a one-row textarea that wraps and auto-grows, re-measured on title and pane-width changes. Enter moves the cursor to the content (titles stay one logical line) and pasted newlines flatten to spaces; the editor tools pin to the title's first line. Needs a quick visual pass with a long title in Live mode before merge.
assignee: steve
label: null
priority: medium
task_status: done
---
Note titles don’t wrap to the next line so on notes with long titles only part of the title is visible. Titles should wrap.