---
id: 01KYC42T9A89S57927MQEWVANB
created: 2026-07-25T07:50:51.434085Z
updated: 2026-07-26T14:06:57.701687Z
type: task
title: Keyboard navigation in browser
project: 01KY6W9951TW0904DT0GGJVGE7
number: 372
sprint: segj1dz
comments:
- id: 01KYF98RDGT65NV8Z089Y9T490
  author: Steve Vine
  at: 2026-07-26T13:19:12.304035Z
  text: |-
    Implemented in PR #362 (shared with NOT-370): https://github.com/Steve-vine/notuvia/pull/362

    Bare ↑/↓ (focus loose, outside the pane area) step a keyboard highlight through the Browse tree's visible note rows — the right Properties panel previews each — and Enter opens the highlighted note into the pane. Row order comes from a pure visibleNotes() walk in browseTree.ts mirroring the render DFS; routing follows the Search view's loose-focus idiom. Unit tests cover the walk; the keyboard feel needs a manual pass before merge.
- id: 01KYFC06N549VK8WBDRVTEPEEP
  author: Steve Vine
  at: 2026-07-26T14:06:57.698467Z
  text: 'Review feedback: notes whose default view is Live/MD autofocused the editor on open, swallowing the arrow keys. Fixed in PR #362 (commit 4310557): opening from the sidebar list no longer focus-steals — a per-note suppress flag gates both autofocus paths (the CM6 mount focus and the DEV-937 title/content placement). Alt+E and the pane''s Read/Live/MD buttons clear the flag, so deliberate edit-mode entry still puts the cursor in the note; the board overlay is unaffected.'
assignee: steve
label:
- feature
priority: medium
task_status: review
---
When in browser mode, if a note is selected in the list, up and down cursor keys should navigate up and down the list, changing the right pane properties for each entry.  Hitting return will display the selected note.