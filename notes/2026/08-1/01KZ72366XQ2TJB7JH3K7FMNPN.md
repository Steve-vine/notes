---
id: 01KZ72366XQ2TJB7JH3K7FMNPN
created: 2026-08-04T18:55:36.157512Z
updated: 2026-08-25T09:01:11.545994Z
type: task
title: Planner cards ID
project: 01KY6W9951TW0904DT0GGJVGE7
number: 388
sprint: segj1dz
comments:
- id: 01KZ8BD1BQZPX5QPNZXHJ639ZA
  author: Steve Vine
  at: 2026-08-05T06:57:30.487002Z
  text: |-
    Done on branch not-388-planner-card-id — PR #380.

    The card id was at 0.5 opacity, the faintest thing on the card. It now takes --text at full strength, which is near-black in light mode and near-white in dark, straight from the theme tokens. The small monospace size keeps the title as the card's anchor line. The "Loose" marker (where an unparented task would show a display id) stays deliberately quieter — it isn't an id.

    Scope: Kanban cards only, as asked. The Gantt row labels in the same Planner tab carry the id at 0.55 opacity too — say the word if you want those matched.

    Verified: npm run check 0/0; npm test 224 pass; npm run build clean. Visual pass is yours (no screen capture here) — worth checking both themes. Moving to Review.
- id: 01KZ8DVA6303NJXNBH29NBKSV3
  author: Steve Vine
  at: 2026-08-05T07:40:15.425466Z
  text: 'Shipped: PR #380, released in 0.14.0. Moving to Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
On cards in the planner make the ID clearer, by making it white in dark mode or black in light mode.