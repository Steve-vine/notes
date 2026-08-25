---
id: 01M0TMW0RMR9A5QBGA18X392W7
created: 2026-08-24T19:45:00.18077Z
updated: 2026-08-25T09:01:43.412906Z
type: task
title: Right pane vertical scroll
project: 01KY6W9951TW0904DT0GGJVGE7
number: 403
sprint: segj1dz
comments:
- id: 01M0W2EG2AHGGKFCGZC6PC799C
  author: Steve Vine
  at: 2026-08-25T09:01:31.594423Z
  text: |-
    Done — PR #393 (branch brief-402-403-live-checkbox-and-panel-scrollbar), landed alongside NOT-402.

    .props-body is the scroll container and its content ran flush to the right edge. macOS paints an overlay scrollbar over the content rather than giving it layout space, so it landed on the controls at each section's right edge. Added 0.6rem clearance.

    Noted while looking: scrollbar-gutter: stable is the purpose-built answer for this and does nothing here — it reserves space only for classic scrollbars, not overlay ones. Padding is the reliable fix on macOS.

    Worth an eyeball: whether 0.6rem is enough clearance and doesn't look lopsided against the panel's existing 0.7rem horizontal padding.
assignee: steve
label: null
priority: medium
task_status: review
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