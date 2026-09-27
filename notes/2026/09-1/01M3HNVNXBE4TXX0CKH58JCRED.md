---
id: 01M3HNVNXBE4TXX0CKH58JCRED
created: 2026-09-27T14:56:13.227714Z
updated: 2026-09-27T15:12:29.348073Z
type: task
title: Editing in one pane, or switching Read/Live/MD, scrolls the note back to the top
project: 01KY6W9951TW0904DT0GGJVGE7
number: 454
sprint: sqsolof
comments:
- id: 01M3HP9ZWTP3Z2XRFECWPDA32V
  author: Steve Vine
  at: 2026-09-27T15:04:02.20247Z
  text: 'PR #457. Reproduced in the WebKit pane lab: when the body under the column is rebuilt (mode switch, or the read view re-rendering while another pane edits) the column is briefly empty and WebKit clamps the offset to the 70px header. The tab-switch scroll memory (NOT-452) now also captures the offset just before such a change and restores it after. Lab: Read pane at 300 with the other pane editing in Live: 70 → 300; Read→Live→Read: 0 → 300; tab remount still 300.'
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
With two panes on the same note side by side, editing in one makes the other pane jump back to the top. Switching a pane between Read, Live and MD also puts the note back at the top. In both cases the column should stay where it was.