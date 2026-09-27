---
id: 01M3HM24A3KE9TWZDTGD6GKBEZ
created: 2026-09-27T14:24:47.42724Z
updated: 2026-09-27T14:27:59.588801Z
type: task
title: Clicking a relative link navigates the app to a 404
project: 01KY6W9951TW0904DT0GGJVGE7
number: 453
sprint: sqsolof
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
Clicking a link like [Relative link](./other-note.md) in a note navigates the whole WebView to a 404 "Not Found" page, and the only way out is to quit the app. Links that aren't a URL the app can open should never navigate the window.