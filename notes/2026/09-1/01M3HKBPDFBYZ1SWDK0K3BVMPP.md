---
id: 01M3HKBPDFBYZ1SWDK0K3BVMPP
created: 2026-09-27T14:12:32.303243Z
updated: 2026-09-27T14:16:48.960444Z
type: task
title: Switching tabs loses the scroll position in a note
project: 01KY6W9951TW0904DT0GGJVGE7
number: 452
sprint: sqsolof
comments:
- id: 01M3HKKH205MKWFWTWXMT74EW5
  author: Steve Vine
  at: 2026-09-27T14:16:48.960041Z
  text: 'PR #455. The tab strip re-keys the whole view on the tab id, so every pane is rebuilt on a switch. Each pane now has a stable key (leaf id, or the overlay''s tab), saves its column offset as it scrolls, and restores it after a remount once the content has rendered (re-trying as the reloaded body lands). Verified in the WebKit pane lab: scrolled to 300, unmounted, remounted with the body arriving late, back at 300.'
assignee: steve
label:
- bug
priority: medium
task_status: review
tech: null
---
Scroll halfway down a note, switch to another tab with the tab strip at the top, switch back: the note is at the top again. The pane should come back exactly where it was left.