---
id: 01M13NJ7RNFBX8VZ2HA96RJ57H
created: 2026-08-28T07:50:18.133949Z
updated: 2026-08-29T09:16:11.240451Z
type: task
title: Note button layout
project: 01KY6W9951TW0904DT0GGJVGE7
number: 406
sprint: segj1dz
comments:
- id: 01M16ASQDWCKVNF2VT71190SM0
  author: Steve Vine
  at: 2026-08-29T08:39:52.507453Z
  text: |-
    Done — PR #395 (branch `brief-406-note-button-layout`).

    What was done:
    - Moved the Insert / Format / Attach buttons out of the `.edit-head` title row in `NotePane.svelte` and into the pane statusbar, immediately left of the [Read|Live|MD] mode switch.
    - They render only while editing and unlocked (`{#if editing && !handle.doc.locked}`) — in Read mode there is no Editor mounted for them to drive, so showing them there would be a dead control.

    Decisions made on the fly:
    - Dropped the bespoke `.icon-tool` CSS rule and reused the statusbar's existing `.icon` button class. The two were pixel-identical (same padding, border, radius, 0.7 opacity, accent hover); one rule is better than two. Icon size went 15 → 14 to match the other statusbar icons.
    - Dropped `tabindex="-1"` on the three buttons. It was there to keep them out of the title → content tab path (DEV-937); now that they sit among the statusbar's other buttons, which are all tabbable, excluding them just made them keyboard-unreachable.
    - Kept the leftward popover opening (`.edit-tools .popover { left: auto; right: 0 }`) — the tools still sit toward the pane's right edge. Checked `.pane` / `.statusbar` for `overflow: hidden`; there is none, so the menus aren't clipped.

    Problems encountered: none. Note the repo has no prettier config, so formatting was matched by hand.

    Verification: `npm run check` (0 errors), `npm run build`, `npm test` (274 tests) all green. Visual confirmation in the running app is still outstanding — worth an eyeball at review.
assignee: steve
label: null
priority: medium
task_status: done
---
On the edit note screen, move the three buttons (Insert, format, attach) from the note title line to the menu bar on the left hand side of [Read|Live|MD].