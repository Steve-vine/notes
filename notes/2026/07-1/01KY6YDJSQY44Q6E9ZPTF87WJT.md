---
id: 01KY6YDJSQY44Q6E9ZPTF87WJT
created: 2026-07-23T07:35:40.599842Z
updated: 2026-07-23T11:03:33.9099Z
type: task
title: Design a keyboard-shortcut scheme for pane navigation & resize
imported_from: linear
assignee: steve
comments:
- id: 01KY6YDSP33YA5N1QX52QQ940D
  author: Steve Vine
  at: 2026-07-23T07:35:47.651122Z
  text: |-
    Steve Vine · 2026-06-20:

    Design resolved. **Scheme: Alt-based, single-press**, with bindings **remappable by design** (central keymap; settings UI to remap is a separate slice — your call on the "change these in settings later" requirement).

    Default keymap: focus `Alt`+arrows · resize nearest divider `Alt`+`Shift`+arrows · split `Alt`+`\` / `Alt`+`-` · close `Alt`+`W` · reset 50/50 `Alt`+`0` · edit `Alt`+`E` / `Esc`. Editor-guarded (pane keys suppressed while typing; only `Esc` intercepted there).

    - Written up in `brief/ui.md` → **PR #28** (https://github.com/Steve-vine/notula/pull/28).
    - Sliced into:
      - **DEV-539** (M4, brief) — central keymap + Alt defaults + dispatcher + `paneTree` neighbour/nearest-split helpers (vitest).
      - **DEV-540** (follow-up) — settings UI to view & remap shortcuts (persisted, reset-to-defaults) + a `?` cheatsheet.

    Holding PR #28 for your merge; I'll close this as Done on merge.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 31
sprint: s6s57kv
---
DEV-527 made dividers keyboard-resizable (Tab to focus a divider, then ←/→ or ↑/↓, Home/End to extremes). That's accessible but **too long-winded in practice** — reaching the right separator can mean tabbing through many focusable elements, and there's no quick way to move focus *between panes* or act on the *active* pane.

This is a **design/planning** issue: come up with a coherent keyboard-shortcut scheme before building it. No new ADR expected unless the scheme turns out to be architecturally significant.

**Questions to resolve**

* Move focus directly **between panes** (e.g. a modifier + arrow to focus the pane in that direction), not via Tab order.
* Resize the **focused/active split** with a chord (e.g. modifier + arrow) without first tabbing to the divider; decide which split a pane-level resize targets in a nested tree.
* Shortcuts for **split** (h/v), **close pane**, **reset split to 50/50**, and **cycle/focus** panes.
* Consistency with existing global shortcuts (Alt+Space capture) and the read/edit toggle; avoid clashing with the editor's own keys while a textarea is focused.
* Discoverability (where the shortcuts are shown) and cross-platform modifier choices (⌘ vs Ctrl).

**Done when:** there's an agreed shortcut scheme written up (and sliced into implementation issue(s)) — not necessarily implemented here.

**Context:** follow-up from DEV-527 (split-pane interaction polish); builds on the pane tree from DEV-516.

---

Linear DEV-537 · M4 — Main UI · created 2026-06-20 · done 2026-06-20