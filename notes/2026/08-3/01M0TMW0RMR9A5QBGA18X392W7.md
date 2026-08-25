---
id: 01M0TMW0RMR9A5QBGA18X392W7
created: 2026-08-24T19:45:00.18077Z
updated: 2026-08-25T08:54:51.138293Z
type: task
title: Right pane vertical scroll
project: 01KY6W9951TW0904DT0GGJVGE7
number: 403
sprint: segj1dz
assignee: steve
priority: medium
task_status: active
---
Add an empty space on the right hand side of the right hand pane so that when the vertical scroll bar appears it doesn’t cover controls.

## Cause

`.props-body` in `PropertiesPanel.svelte` is the scroll container
(`overflow-y: auto`) and its content runs flush to its right edge. macOS uses
**overlay** scrollbars, which are painted over the content rather than taking
layout space, so the bar lands on top of whatever sits at that edge.

`scrollbar-gutter: stable` is the purpose-built answer but does nothing here —
it only reserves space for classic scrollbars, not overlay ones.

## Agreed work

Give `.props-body` a right padding wide enough to clear an overlay scrollbar, so
the controls at the right edge of each section sit inside it.