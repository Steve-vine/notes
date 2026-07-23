---
id: 01KY6Y0JTEFDEH7Z4D2WFZRSCZ
created: 2026-07-23T07:28:34.63818Z
updated: 2026-07-23T11:00:28.283131Z
type: task
title: Tray presence & app lifecycle
imported_from: linear
comments:
- id: 01KY6Y0X5TVPZF36E6Q4JS3TQX
  author: Steve Vine
  at: 2026-07-23T07:28:45.242212Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done** (all in `src-tauri`)
    - **Tray** menu-bar icon + menu (**New note / Open full UI / Quit**) via `TrayIconBuilder` + `Menu`/`MenuItem`; enabled the `tray-icon` Cargo feature. Menu shows on left click.
    - **Global hotkey Option+Space** via `tauri-plugin-global-shortcut` (desktop-cfg dep), registered system-wide.
    - **Single-instance** via `tauri-plugin-single-instance`, registered first — second launch focuses the running instance.
    - **Resident lifecycle:** `WindowEvent::CloseRequested` → hide window + `prevent_close()` (close-to-tray, app stays alive; Quit only via tray). Switched to `.build()?.run(..)` to handle macOS `RunEvent::Reopen` (dock-icon click re-shows the window).
    - Helper `show_main_window()` shared by tray, hotkey, single-instance, and reopen paths.

    **Decisions / things to know at review**
    - `new_note` + the hotkey are **placeholders** that focus the main window — the real capture window lands in **M3**; code comments mark the seam.
    - Kept the **dock icon** (Regular activation policy) per the agreed UX; no new ADR (config within ADR 0002/0008).
    - A stray machine-local `.claude/scheduled_tasks.lock` appeared during the session — left **uncommitted** (out of scope). Minor: could gitignore `.claude/*.lock` later.

    **Verification**
    - `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `npm run tauri build` all pass; bundle builds and the app launches/runs.
    - **Manual sign-off needed** (assistive-access blocks automated UI checks): tray icon visible, menu launches window, close-to-tray keeps it resident, Option+Space focuses, second launch focuses existing, dock click re-shows.

    **PR:** https://github.com/Steve-vine/notula/pull/4
    **Branch:** `brief-479-tray-presence-app-lifecycle` · commit `d6c82e8`
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 4
sprint: s87b0qx
---
Make Notula a resident background app with a tray presence and global-hotkey plumbing.

**Checklist**

- [X] Tray (menu-bar) icon
- [X] Extensible tray menu (start with: New note, Open full UI, Quit)
- [X] Global hotkey registration plumbing (the capture window it triggers lands in M3) — Option+Space
- [X] Single-instance enforcement
- [X] App keeps running when all windows are closed (lives in the tray)

**Done when:** closing all windows leaves Notula resident in the tray, and the menu can launch windows.

---

### Agreed approach (planned 2026-06-19)

* **Global hotkey: Option+Space** via `tauri-plugin-global-shortcut`. Placeholder focuses the main window until the capture window lands in M3.
* **Presentation:** keep the **dock icon** (Regular); close-to-tray (hide, not destroy); quit only via the tray; dock-click re-shows (`RunEvent::Reopen`).
* **Launch:** show the main window.
* **Tray:** `TrayIconBuilder` + `Menu`/`MenuItem` (`tray-icon` feature) — New note / Open full UI / Quit, menu on left click.
* **Single instance:** registered first; second launch focuses the running instance.
* All in `src-tauri`; no frontend change; CI unchanged; no new ADR (within ADR 0002/0008).

**PR:** [https://github.com/Steve-vine/notula/pull/4](<https://github.com/Steve-vine/notula/pull/4>)

---

Linear DEV-479 · M1 — Foundation · created 2026-06-19 · done 2026-06-19