---
id: 01KY6YA964RXGK7CMF4XY27F77
created: 2026-07-23T07:33:52.452936Z
updated: 2026-07-23T09:08:57.124593Z
type: task
title: Split-pane interaction polish
assignee: steve
task_status: done
comments:
- id: 01KY6YAG0DWVB6PZD5V04RG15T
  author: Steve Vine
  at: 2026-07-23T07:33:59.436998Z
  text: |-
    Steve Vine · 2026-06-20:

    PR: https://github.com/Steve-vine/notula/pull/26 — In Review.

    - **Pane.svelte** — divider is now a focusable ARIA separator with keyboard resize (arrows + Home/End), pointer capture for smooth fast drags, a larger invisible hit area, double-click → 50/50, and a light centre snap. The existing 0.1–0.9 ratio clamp covers the "can't drag to nothing" item.
    - **paneTree.ts** — `reviveTree()` validates a persisted tree and bumps the id counter past restored ids (no collisions).
    - **Main.svelte** — pane tree restored from localStorage on init, persisted on change → layout + each pane's note survive a restart.
    - **First JS tests** — vitest harness for paneTree helpers + reviveTree (8 tests); `npm test` wired into the CI test job.

    All gates green locally: `npm test` (8), `npm run check` (0 warnings), `cargo fmt --check` / `clippy -D warnings` / `cargo test` (42), `npm run tauri build`.

    Holding for your manual sign-off (fast drag stays glued; double-click reset; Tab + arrow-key resize; split/open notes/restart → restored) + CI before merge.
- id: 01KY6YAN969H9D0SHZYM3272Q1
  author: Steve Vine
  at: 2026-07-23T07:34:04.838088Z
  text: |-
    Steve Vine · 2026-06-20:

    Fixed two regressions Steve found while testing resize:
    - **Pane flicker / content reload on resize** and **edit mode collapsing to read** — same root cause: `NotePane`'s acquire effect re-ran on every resize (the tree rebuild re-runs it with the same noteId), releasing + re-acquiring the shared handle each time → reload from disk + `editing` reset. The DEV-516 noteId guard had been dropped in DEV-532; reinstated it (swap handles only when the note id actually changes; release on unmount via `onDestroy` instead of the effect cleanup).

    `npm run check` clean, `npm test` 8/8, `npm run tauri build` green. Pushed to PR #26.

    **Resize shortcuts:** Tab to focus a divider, then ←/→ (side-by-side) or ↑/↓ (stacked); Home/End jump to 10%/90%.
label: follow_up
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 24
---
Deferred from DEV-516 (functional split/resize/close shipped hand-rolled). Bring the divider/pane interaction up to library-grade feel — no structural change to the pane tree, these layer onto the existing `Pane.svelte` divider.

**Checklist**

- [ ] Keyboard-resizable dividers (focusable, arrow keys) + ARIA `role="separator"` / `aria-orientation`
- [ ] Larger invisible hit-area around the 4px divider; `setPointerCapture` so fast drags stay smooth even when the cursor outruns the handle
- [ ] Double-click a divider to reset the split to 50/50
- [ ] Min-size handling / snap so a pane can't be dragged to nothing
- [ ] Layout persistence across restarts (serialise the pane tree, e.g. into app config)
- [ ] (Optional) a JS unit harness (vitest) for `paneTree.ts` helpers + wire a frontend test step into CI

**Done when:** divider resize is keyboard-accessible and feels smooth/robust, and the split layout survives a restart.

**Notes:** purely frontend; no new ADR. The structure (pane tree + recursive `Pane`) is in place from DEV-516.

---

Linear DEV-527 · M4 — Main UI · created 2026-06-20 · done 2026-06-20