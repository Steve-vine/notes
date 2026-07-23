---
id: 01KY72SB2QXQ2A1HCYZQ4QPRQX
created: 2026-07-23T08:52:00.215644Z
updated: 2026-07-23T11:03:35.276985Z
type: task
title: Remappable global New Note hotkey
imported_from: linear
assignee: steve
priority: medium
task_status: done
project: 01KY6W9951TW0904DT0GGJVGE7
number: 311
sprint: sf9yevt
---
## Context

The New Note capture hotkey is hardcoded as Alt+Space in the Tauri backend (`src-tauri/src/lib.rs`, `Shortcut::new(Some(Modifiers::ALT), Code::Space)`) and registered once at startup via `tauri_plugin_global_shortcut`. DEV-963 made it visible on the Shortcuts screen, but it's read-only — unlike every pane binding, the user can't change it, even though a global Alt+Space can collide with other apps (and is Finder's default "Spotlight-adjacent" territory on some setups).

## Change

Make the global capture hotkey remappable from the Shortcuts screen:

* **Config**: persist the chosen shortcut in the app config (`config.rs`), defaulting to Alt+Space; migrate nothing — absent means default.
* **Backend commands**: `get_capture_shortcut` / `set_capture_shortcut` — setting unregisters the old shortcut and registers the new one live, returning an error if the OS rejects the registration (already claimed by another app) so the UI can keep the old binding and show why.
* **Frontend**: the DEV-963 "Global" row becomes a capture-style binding button like the pane rows (click, press the new chord). Needs modifier handling for a *global* chord — require at least one modifier (a bare letter as a system-wide hotkey would be hostile), and validate against the plugin's accepted codes.
* **Reset**: "Reset to defaults" in the shared footer should also restore Alt+Space.

## Acceptance

* Rebinding takes effect immediately (no restart) and survives a restart.
* A rejected registration (OS conflict) leaves the previous hotkey active with a clear error in the row's help line.
* Reset restores Alt+Space, and the row always shows the live binding.

---

Linear DEV-964 · Settings Window · created 2026-07-12 · done 2026-07-12