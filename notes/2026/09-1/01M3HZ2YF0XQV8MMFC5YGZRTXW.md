---
id: 01M3HZ2YF0XQV8MMFC5YGZRTXW
created: 2026-09-27T17:37:28.544969Z
updated: 2026-09-27T17:47:02.011566Z
type: task
title: Read and Live text colours differ
project: 01KY6W9951TW0904DT0GGJVGE7
number: 460
sprint: sqsolof
comments:
- id: 01M3HZ7Q2RBYMVBDFSW0YYMZ79
  author: Steve Vine
  at: 2026-09-27T17:40:04.823661Z
  text: 'PR #462. The colours are identical: every element pair (paragraph, headings, bold, italic, code, link, strike, highlight, lists, quote, code block, table, footnotes) measured the same computed colour/background/opacity in both views and both themes, with matching font family, size, weight and smoothing. The "muted Read" was the DEV-771 rule dimming an inactive pane''s content to 70%: side by side, the Read pane is the unfocused one. Now only the header dims.'
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
The colours are slightly different between Read and Live view; Read is slightly more muted in general. Match the colours across both modes.