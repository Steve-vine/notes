---
id: 01KY70P89ZY4FM8KREX6Q6VXQ0
created: 2026-07-23T08:15:21.919081Z
updated: 2026-07-23T09:18:28.277014Z
type: task
title: Import/Export buttons
task_status: done
label: null
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 162
comments:
- id: 01KY70PCSM97EDYKVN91SVF4G7
  author: Steve Vine
  at: 2026-07-23T08:15:26.516259Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/144

    **What was done:** `Sidebar.svelte` gained a `showIo` prop gating the three I/O footer buttons (import files, import folder, export); `Main.svelte` passes `active.mode === "browse"`. Settings, sync indicator, and the collapse chevron remain in every view.

    **Decisions on the fly:** The issue said "the 2 import and export buttons" — there are actually three (file import, folder import, export); I hid all three, since folder import is the same class of action. Dashboard mode also loses them, matching "only the browse view".

    **Problems:** None. `npm run check` and `npm test` green.
sprint: sg5stzf
---
The 2 import and export buttons shouldn't show on kanban view, only the browse view.

## Agreed work

* `Sidebar.svelte` gains a `showIo` prop; the footer's import, import-folder, and export buttons render only when it's true. The settings button and sync indicator stay in every view.
* `Main.svelte` passes `showIo={active.mode === "browse"}`, so the I/O buttons appear on the Browse view only (not Kanban, not Dashboard).
* Checks: `npm run check`, `npm test`.

---

Linear DEV-800 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04