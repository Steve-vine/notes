---
id: 01M3HM24A3KE9TWZDTGD6GKBEZ
created: 2026-09-27T14:24:47.42724Z
updated: 2026-09-27T15:12:28.668921Z
type: task
title: Clicking a relative link navigates the app to a 404
project: 01KY6W9951TW0904DT0GGJVGE7
number: 453
sprint: sqsolof
comments:
- id: 01M3HM874FR8ZWY0XKPZ9AY8YF
  author: Steve Vine
  at: 2026-09-27T14:28:06.926776Z
  text: 'PR #456. The read view only handled attachments, the TOC and web/mail links; anything else fell through to the WebView''s own navigation. A window-level guard in the page root now has the last word on every anchor in every window: web/mail open in the OS, in-page anchors stay, anything else is stopped, and the read view shows "Can''t open "./other-note.md": not a web address, an attachment or a note." Four unit tests on the decision.'
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Clicking a link like [Relative link](./other-note.md) in a note navigates the whole WebView to a 404 "Not Found" page, and the only way out is to quit the app. Links that aren't a URL the app can open should never navigate the window.