---
id: 01M1Y983FD9ZZYQNY4JFQ441J8
created: 2026-09-07T15:54:32.813707Z
updated: 2026-09-08T14:40:48.897799Z
type: task
title: Pop-out window's Properties panel can't be resized
project: 01KY6W9951TW0904DT0GGJVGE7
number: 415
sprint: segj1dz
comments:
- id: 01M1Y9EN4312GB4NXA5YSZMN4X
  author: Steve Vine
  at: 2026-09-07T15:58:07.491543Z
  text: |-
    Built on brief-415-pop-out-panel-resize — PR #412.

    Cause: NoteWindow.svelte used a fixed 248px grid track with no divider, so the panel could only be collapsed, never dragged.

    Rather than copy Main's ~80 lines of resize handling plus its CSS into the pop-out, extracted them: PanelDivider.svelte (drag with pointer capture, double-click reset, arrow nudge, clamp, styling) over panelWidth.ts (bounds + load/persist, unit-tested). Both windows use it, so the two dividers are the same component, not two similar ones. Net -140 lines from Main.svelte.

    Widths stay per host — sidebar, main window panel, and pop-out panel each keep their own localStorage key.

    Note for review: this moves working code in the main window, so both of its dividers want checking alongside the new one. One deliberate behaviour change: double-clicking a collapsed panel's boundary no longer resets its width (it used to, invisibly).

    Checks: npm run test (323 pass, incl. 6 new), npm run check (0 errors, 0 warnings), npm run build — clean. No Rust touched.
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: done
tech: null
---
Follow-up from NOT-413. The pop-out note window (`NoteWindow.svelte`) lays the Properties panel out on a fixed 248px grid track with no divider, so unlike the main window it can't be dragged wider or narrower — only collapsed to the rail.

The main window's resizable panels (DEV-777) live entirely inside `Main.svelte`: ~80 lines of pointer/keyboard drag handling, the width clamp and localStorage persistence, plus the `.panel-divider` CSS. Copying that into the pop-out would duplicate all of it.

Fix: extract the divider into a shared `PanelDivider.svelte` plus a small `panelWidth.ts` (clamp, load, persist, and the default/min/max), then use it in both windows — so the pop-out and the main window are literally the same code.