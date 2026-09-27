---
id: 01M3HH6B11EPT416DMBKY25PM5
created: 2026-09-27T13:34:39.64999Z
updated: 2026-09-27T13:45:17.139709Z
type: task
title: Live code blocks grow to fit long lines instead of scrolling
project: 01KY6W9951TW0904DT0GGJVGE7
number: 449
sprint: sqsolof
comments:
- id: 01M3HHBB1VDK7P7HSF22D1YXCN
  author: Steve Vine
  at: 2026-09-27T13:37:23.514951Z
  text: 'PR #453. Cause: CodeMirror''s content element is a flex item of its scroller, and a flex item''s automatic minimum width is its min-content width, which an unbreakable code line sets — measured in WebKit: a 1149px line in a 640px column made the content, the widget and the code box all 1149px. min-width: 0 on the content lets it shrink to the scroller; the box''s own overflow-x then scrolls, as in Read. Also covers wide tables.'
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
In Read mode a code block whose text doesn't fit the width scrolls horizontally inside the box. In Live mode the same block is rendered wide enough to fit the text, so the box runs off the right-hand side of the page.