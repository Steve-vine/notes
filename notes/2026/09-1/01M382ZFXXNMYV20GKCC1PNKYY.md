---
id: 01M382ZFXXNMYV20GKCC1PNKYY
created: 2026-09-23T21:33:05.341994Z
updated: 2026-09-23T21:33:41.70047Z
type: task
title: 'UI redesign: native app menu — import, export, sync now, suggest a feature'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 432
sprint: sqsolof
assignee: steve
label:
- improvement
priority: medium
task_status: todo
tech: null
---
The sidebar footer loses import file, import folder, export, the feature-request lightbulb and the sync pill. Move them to the native Notuvia menu:
- File: Import markdown files…, Import a folder…, Export the notes in this view…, Sync now.
- Help: Suggest a feature.
- Wire menu events to the existing frontend actions (same pattern as the About item's `open-about` event in src-tauri/src/lib.rs).
- macOS extends the default app menu; Windows/Linux gain a menu bar with the same items.