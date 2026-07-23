---
id: 01KY6YEP7S2ZGV492NXJ52KBHR
created: 2026-07-23T07:36:16.889477Z
updated: 2026-07-23T09:08:57.183019Z
type: task
title: Settings UI to view & remap keyboard shortcuts
assignee: steve
label: follow_up
task_status: done
comments:
- id: 01KY6YEXGAPJBEAQ8E2G93EH9M
  author: Steve Vine
  at: 2026-07-23T07:36:24.330598Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/30 — In Review.

    First settings surface — a modal listing every shortcut (cheatsheet), rebindable with conflict flagging + reset-to-defaults, persisted in localStorage and applied over the code defaults.

    - **keymap.ts** — labels/order, `bindingLabel` (code→glyph), `conflicts`, `mergeKeymap`; new `showShortcuts` action (`?`).
    - **keymapStore.svelte.ts** — reactive active keymap (defaults + localStorage overrides); `rebind`/`resetAll`; `keymap()` used by the dispatcher + UI.
    - **Settings.svelte** — backdrop modal; click a binding then press a key to rebind (Esc cancels), conflicts highlighted, Reset to defaults.
    - **Main.svelte** — dispatcher now resolves against the live `keymap()`; `?` and a sidebar **⌨ Shortcuts** button open it; onKey yields while open.

    Gates green: 24 vitest, `npm run check` clean, 42 cargo tests, `npm run tauri build`.

    Holding for your manual sign-off (open via button + `?`; rebind takes effect + persists across restart; conflict flagged; reset restores defaults; no firing while typing) + CI before merge.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 33
---
Let the user view and **remap** keyboard shortcuts from a settings surface, overriding the code-defined defaults (DEV-537 requirement: the keymap is built remappable; this is the UI for it).

**Checklist**

- [ ] A settings surface (creating one if none exists yet) listing actions + their current bindings.
- [ ] Capture a new binding per action; detect/flag conflicts; **reset-to-defaults**.
- [ ] Persist user overrides (e.g. localStorage or app `config.json`) and apply them over the default keymap on load.
- [ ] A discoverable shortcuts cheatsheet (e.g. a `?` overlay) — or fold the list into the settings view.

**Done when:** a user can rebind a pane shortcut, it persists across restart, and can be reset to the default.

**Notes:** depends on the central keymap from the implementation issue. Likely needs a settings screen, which may be its own first step. No new ADR expected.

---

Linear DEV-540 · M4 — Main UI · created 2026-06-20 · done 2026-06-21