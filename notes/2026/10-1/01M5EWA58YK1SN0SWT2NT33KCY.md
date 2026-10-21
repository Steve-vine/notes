---
id: 01M5EWA58YK1SN0SWT2NT33KCY
created: 2026-10-21T09:22:39.518216Z
updated: 2026-10-21T12:39:04.912012Z
type: task
title: Select range
project: 01KY6W9951TW0904DT0GGJVGE7
number: 548
sprint: sd52non
comments:
- id: 01M5EX310TBWN8N262T6C7DJPC
  author: Steve Vine
  at: 2026-10-21T09:36:14.362018Z
  text: 'Merged to main as #542 (brief-548-shift-range-select). Shift-click on a Kanban card adds every card from the primary (the card last picked) to the clicked one, in board order — down the column and on into the next — and makes the clicked card the primary. Cmd/Ctrl-click still toggles single cards; cards picked earlier outside the range stay picked; with nothing selected a Shift-click is a plain click. A Shift mousedown takes the card''s focus so the WebView doesn''t extend a text selection across the cards between. Range maths (clickMode, rangeCards, extendSelection) is unit-tested in boardSelect.ts. Not yet seen in-app: check the ring on the whole range, a cross-column range, and that a group drag then moves the lot.'
assignee: steve
priority: medium
task_status: done
tech: null
---
Previously we added the capability to select multiple Kanban cards by holding down CMD, add the ability to use SHIFT to select a range. E.g. click a card, hold down shift and click another card, all cards in the range are selected.