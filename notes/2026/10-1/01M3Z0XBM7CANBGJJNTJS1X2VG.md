---
id: 01M3Z0XBM7CANBGJJNTJS1X2VG
created: 2026-10-02T19:19:30.183054Z
updated: 2026-10-02T19:55:02.608453Z
type: task
title: 'CrossSync rail view: list, add, link and manual sync'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 493
sprint: sx287fa
blocked_by:
- 01M3Z0X0YPXCMK1VQ6APM9N45G
comments:
- id: 01M3Z2YDT2SSXKWGFAMYEA1Y75
  author: Steve Vine
  at: 2026-10-02T19:55:02.3358Z
  text: |-
    Built and merged (squash, PR #483), CI green. The branch is deleted.

    What landed:
    - A CrossSync entry on the view rail (swap glyph), wired through ViewMode, reviveMode, the tab order, the rail icons and Main.svelte. A saved CrossSync tab survives a restart.
    - The list: name, the machine that added it, the path on this machine (home shown as ~) and a status with a coloured dot.
    - Add file: a path field plus Browse, with the unencrypted-storage warning in the form.
    - Link: suggests ~/<name>; asks once before replacing a different file and says a backup is kept.
    - Row actions: Sync now, change location, Unlink, Remove (inline confirmation). Sync all in the header. Empty state and a sidebar section explaining the feature.
    - New xsync_link_preview command (new / same / different) behind the replace confirmation.

    Decided on the fly:
    - The add form has a typed path field as well as the picker, because the macOS picker hides dotfiles until Cmd+Shift+. is pressed.
    - Confirmations are inline panels in the row, not system dialogs; the app has no dialog-confirm idiom.
    - Statuses also refresh when the window regains focus.
    - Browse in the link form picks an existing file only; a path that doesn't exist yet is typed.

    Verification: npm test 513/513, npm run check 0 errors, xsync Rust tests 18/18, fmt and clippy clean. Layout checked in the UI lab with headless Chrome (dark and light, link confirmation, add form). Not run in the Tauri app: the picker and a real add/link round trip still need a pass from Steve.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
So that CrossSync is usable end to end from the app, with manual sync, before the automatic pieces land. Builds on the core engine task.

## Agreed work

- [ ] New `crosssync` view mode with a rail entry labelled "CrossSync" and a Phosphor icon generated via `scripts/gen-icons.mjs` (ADR 0063).
- [ ] Wire the mode everywhere modes are listed: the `ViewMode` union and `reviveMode` in `tabsStorage.ts`, `VIEW_TAB_IDS` / `VIEW_TAB_LABELS` in `viewTabs.ts`, `VIEW_ICONS` in `ViewRail.svelte`, and the sidebar, main-panel and selection branches in `Main.svelte`. A saved CrossSync tab must survive a restart, not fall back to Browse.
- [ ] File list: one row per entry in `xsync/`, showing its name, which machine added it, this machine's local path, and a status: in sync, local changed, vault changed, conflict, missing, or not linked here.
- [ ] "Add file" opens the system file picker (dialog plugin), with hidden files reachable, then calls the add command.
- [ ] An entry that is not linked on this machine offers a path field plus a Browse button, and a Sync button that links it and copies the vault file out. If a different file already exists at that path, confirm before overwriting and say a backup is kept.
- [ ] Per-row actions: Sync now, Unlink (keeps both files), Remove (deletes the vault copy for every machine, never the local originals; confirm first).
- [ ] A "Sync all" action, and an empty state explaining what CrossSync is for.
- [ ] Adding a file shows a short warning that the copy is stored unencrypted in the vault and its sync remote, so files holding tokens or passwords shouldn't be added.
- [ ] Styled with the existing Nocturne tokens. Tests for the mode wiring (`reviveMode`, tab order) and the list's status rendering.

## Notes

Status refreshes on view open and after each action in this task; live updates arrive with the automatic-sync task. A visual pass in the running app needs Steve (no screen capture).