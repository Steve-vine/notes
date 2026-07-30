---
id: 01KYPAGZWS1BS5GG4K9N6C55F8
created: 2026-07-29T06:55:51.705282Z
updated: 2026-07-30T13:16:43.007682Z
type: task
title: Unable to reorganise top tabs in full screen
project: 01KY6W9951TW0904DT0GGJVGE7
number: 376
order: 0.0
sprint: segj1dz
comments:
- id: 01KYSFGSJ6TK77PN55AXPMJT38
  author: Steve Vine
  at: 2026-07-30T12:20:51.398106Z
  text: |-
    Fix up for review: PR #368 (branch not-376-fullscreen-tab-reorder).

    Cause: both top strips (tab strip and view tabs) reordered via HTML5 drag-and-drop, which is a native macOS drag session — at the top of a fullscreen window the menu-bar auto-reveal breaks it. Reordering now uses the in-page pointer-capture drag pattern the rest of the app uses (pane dividers, workspace icons), so it behaves identically windowed and fullscreen.

    Please give both strips a drag in both modes when reviewing — the mechanics changed (4px threshold before a drag starts; click still switches tabs; drop doesn't switch).
assignee: steve
label:
- bug
priority: medium
task_status: done
---
When in full screen mode it isn’t possible to reorganise the top tabs.