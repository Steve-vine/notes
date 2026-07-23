---
id: 01KY6YE7AH1E87B7H7T0QZYAPZ
created: 2026-07-23T07:36:01.617893Z
updated: 2026-07-23T12:24:58.023542Z
type: task
title: 'Pane keyboard shortcuts: central keymap + Alt-based defaults'
assignee: steve
comments:
- id: 01KY6YEK1HTECHBCHNJHGDSNHX
  author: Steve Vine
  at: 2026-07-23T07:36:13.61663Z
  text: |-
    Steve Vine · 2026-06-20:

    PR: https://github.com/Steve-vine/notula/pull/29 — In Review.

    - **keymap.ts** — central `defaultKeymap` + pure `resolveAction` (ignores Ctrl/Meta so OS chords pass through); data-driven for DEV-540's remap UI.
    - **paneTree.ts** — `directionalNeighbour` (focus target) + `nearestSplitAlong` (resize target), pure + unit-tested.
    - **Main.svelte** — window-level dispatcher: focus `Alt`+arrows, resize `Alt`+`Shift`+arrows (nearest divider), split `Alt`+`\`/`-`, close `Alt`+`W`, reset `Alt`+`0`, edit `Alt`+`E`, `Esc` to leave. Editor-guarded (only `Esc` honoured while typing). Edit state lifted here per-leaf so the dispatcher can toggle the active pane; Pane/NotePane now take read/edit as a controlled prop.

    Gates green: 18 vitest, `npm run check` clean, 42 cargo tests, `npm run tauri build`.

    Holding for your manual sign-off (Alt+arrows focus, Alt+Shift+arrows resize, split/close/reset, Alt+E/Esc edit, no firing while typing, Alt+Space still works) + CI before merge.
task_status: done
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 32
sprint: s6s57kv
---
Implement the agreed pane keyboard-shortcut scheme (DEV-537; spec in `brief/ui.md` → Full UI → Keyboard shortcuts). Default scheme is Alt-based and single-press; bindings must be **data-driven and remappable** (the settings UI to remap is a separate issue).

**Checklist**

- [ ] A central **keymap module**: `action id → binding(s)` with the defaults defined in code (focus/resize/split/close/reset/edit). Structured so a later settings layer can override + reset (don't hard-code key checks in components).
- [ ] A single window-level `keydown` dispatcher (in `Main.svelte`, which owns the pane tree + `activeLeafId`) that resolves the active binding → dispatches the action against the active pane.
- [ ] **Editor guard:** suppress the pane keymap while a text field is focused; only `Esc` (blur → read mode) is intercepted there.
- [ ] New pure `paneTree.ts` helpers (with vitest tests, per DEV-527's harness): **directional neighbour** of the active leaf (focus) and **nearest enclosing split** along an axis (resize). Resize reuses `setRatio`'s 0.1–0.9 clamp.
- [ ] Wire actions: focus `Alt`+arrows; resize `Alt`+`Shift`+arrows; split `Alt`+`\` / `Alt`+`-`; close `Alt`+`W`; reset `Alt`+`0`; edit `Alt`+`E`, `Esc` to leave edit. Active pane already shows a focus ring.
- [ ] No clash with the global `Alt`+`Space` capture hotkey.

**Done when:** the pane can be focused/resized/split/closed/reset entirely from the keyboard per the spec, the keymap is remappable in principle (config-driven), and the `paneTree` helpers are unit-tested.

**Notes:** purely frontend. No new ADR. Builds on DEV-516 (pane tree) / DEV-527 (divider + vitest).

---

Linear DEV-539 · M4 — Main UI · created 2026-06-20 · done 2026-06-20