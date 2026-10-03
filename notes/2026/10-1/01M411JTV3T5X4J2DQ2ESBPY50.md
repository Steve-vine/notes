---
id: 01M411JTV3T5X4J2DQ2ESBPY50
created: 2026-10-03T14:09:42.755666Z
updated: 2026-10-03T14:10:48.985778Z
type: task
title: 'Capture from anywhere on every desktop: per-platform hotkey defaults and a `--capture` fallback'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 500
sprint: sw66q9v
assignee: steve
label:
- brief
- feature
priority: high
task_status: backlog
tech: null
---
So that the core promise — capture from anywhere with one keystroke — holds on Windows and Linux, not just macOS. Today's default is `Alt+Space` (`lib.rs` `default_capture_shortcut`). On Windows and GNOME that is the window menu. Under Wayland, `tauri-plugin-global-shortcut` cannot register global shortcuts at all.

**Draft — re-plan after NOT-498 reports.**

## Proposed work

- [ ] Per-platform default shortcut: macOS keeps `Alt+Space` (a user's saved setting is never changed); Windows and Linux default to a combination that isn't claimed by the shell (`Ctrl+Alt+Space` proposed).
- [ ] `notuvia --capture` as a universal fallback: the single-instance plugin already forwards argv to the running instance; a `--capture` argument opens the capture window. Works on every platform, and is the *only* route on Wayland, where the user binds a key in their desktop's own keyboard settings to that command.
- [ ] When the shortcut can't be registered (Wayland, or the combination is taken), the app says so once in Settings → Capture with the `--capture` instructions, rather than silently having no hotkey.
- [ ] Tray: verify the tray icon and menu appear on Windows, GNOME (needs the AppIndicator extension — say so in docs) and KDE; "Capture" stays in the tray menu as the mouse route.
- [ ] Docs: a short per-platform "setting up capture" section.

## Notes

ADR 0068 records the fallback as the decision; this brief implements it. The XDG GlobalShortcuts portal is the longer-term Wayland answer, but the plugin doesn't speak it yet — revisit when it does.