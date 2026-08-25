---
id: 01KZ77FFJDX7BG02MM9E9DGSPV
created: 2026-08-04T20:29:41.837689Z
updated: 2026-08-25T09:01:11.639756Z
type: task
title: New memo note options
project: 01KY6W9951TW0904DT0GGJVGE7
number: 389
sprint: segj1dz
comments:
- id: 01KZ8BPAYXDJ3YNPET72XWQB2W
  author: Steve Vine
  at: 2026-08-05T07:02:35.226664Z
  text: |-
    Done on branch not-389-memo-project — PR #381.

    The capture window offered the Project picker to Tasks only, while the note editor already offers it to Tasks, Memos and Schedules — so a memo could only be filed under a project after saving it, by opening it in the main window. The picker now shows for every Type that can carry the project edge, and the rule moved into projectLink.ts which both surfaces read, so they can't drift apart again.

    Task-only extras are untouched: only a Task gets the sprint picker and the per-project number. The backend already accepted a memo's project link (ADR 0038) and files it under the project's Reference section, so this was purely the capture form gating it.

    Scope note: Schedules ride along, since the editor already allows it and the notes a schedule mints inherit its link (ADR 0047) — one rule rather than a third variant. Say the word if you'd rather capture stayed Memo-only.

    Verified: new projectLink test; npm run check 0/0; npm test 227 pass; npm run build clean. Visual pass is yours (no screen capture here) — open capture, switch Type to Memo, pick a project, save, and it should land under that project's Reference section. Moving to Review.
- id: 01KZ8DVH5HMB2HFGM1GZAKDG2T
  author: Steve Vine
  at: 2026-08-05T07:40:22.57537Z
  text: 'Shipped: PR #381, released in 0.14.0. Moving to Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
On new note window, if ‘Memo’ is selected, allow the choosing of a project to associate it with.