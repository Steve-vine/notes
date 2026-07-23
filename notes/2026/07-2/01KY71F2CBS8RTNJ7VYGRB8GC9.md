---
id: 01KY71F2CBS8RTNJ7VYGRB8GC9
created: 2026-07-23T08:28:55.051207Z
updated: 2026-07-23T09:08:58.28706Z
type: task
title: Window size
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 220
comments:
- id: 01KY71F7GTPB48KBJJTX39N1J4
  author: Steve Vine
  at: 2026-07-23T08:29:00.313768Z
  text: |-
    Steve Vine · 2026-07-07:

    **Planned work (Claude, 2026-07-07):** add the official `tauri-plugin-window-state` (v2), configured to persist **size + position** (agreed with Steve) for both windows by label — "main" restores automatically at startup; the dynamically created "capture" window gets an explicit `restore_state` after creation so its saved geometry beats the hardcoded 720×570 default (which remains the first-ever-open size). State lives in the app-config dir alongside `config.json`. No frontend changes.
- id: 01KY71FBCSGN0Y00166CK3XCPG
  author: Steve Vine
  at: 2026-07-23T08:29:04.280292Z
  text: |-
    Steve Vine · 2026-07-07:

    **Build complete — PR [#204](https://github.com/Steve-vine/notuvia/pull/204)**. `tauri-plugin-window-state` v2 persisting size + position per window: main restores automatically, the capture window restores explicitly after its dynamic creation (720×570 is now just the first-ever size). Backend-only; gates clean. Manual check: resize/move both windows, quit, relaunch.
---
Remember the size of the Main app window and New note window so that if it gets resized, it always opens at the same size.

---

Linear DEV-873 · Backlog · created 2026-07-07 · done 2026-07-07