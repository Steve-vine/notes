---
id: 01M1Y983FD9ZZYQNY4JFQ441J8
created: 2026-09-07T15:54:32.813707Z
updated: 2026-09-07T15:54:37.160485Z
type: task
title: Pop-out window's Properties panel can't be resized
project: 01KY6W9951TW0904DT0GGJVGE7
number: 415
sprint: segj1dz
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: active
---
Follow-up from NOT-413. The pop-out note window (`NoteWindow.svelte`) lays the Properties panel out on a fixed 248px grid track with no divider, so unlike the main window it can't be dragged wider or narrower — only collapsed to the rail.

The main window's resizable panels (DEV-777) live entirely inside `Main.svelte`: ~80 lines of pointer/keyboard drag handling, the width clamp and localStorage persistence, plus the `.panel-divider` CSS. Copying that into the pop-out would duplicate all of it.

Fix: extract the divider into a shared `PanelDivider.svelte` plus a small `panelWidth.ts` (clamp, load, persist, and the default/min/max), then use it in both windows — so the pop-out and the main window are literally the same code.