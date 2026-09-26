---
id: 01M3EHB4SW182EK65MYYMPWSN5
created: 2026-09-26T09:39:43.341578Z
updated: 2026-09-26T12:44:36.584418Z
type: task
title: Text glitch between modes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 448
sprint: sqsolof
comments:
- id: 01M3EVA78WGRQFREB3FN78GRRF
  author: Steve Vine
  at: 2026-09-26T12:33:49.340026Z
  text: 'PR #450. Cause: CodeMirror wraps under white-space: break-spaces, where the space after a word must fit on the line too; the read view lets it hang. So a word that fit by less than a space''s width dropped down in Live only. The editor now uses pre-wrap for wrapping content. Verified in a WKWebView (Chrome couldn''t reproduce): the compare lab sweeps the column 520→700px and reports every line''s end text; break-spaces mismatched at 4 of 6 boundary widths, pre-wrap matches at all 31.'
- id: 01M3EVXZB8RX6SFN1ZCNXSXWMW
  author: Steve Vine
  at: 2026-09-26T12:44:36.583026Z
  text: |-
    Read View
    /Users/steve/Library/Application Support/CleanShot/media/media_v1fBUBYORd/CleanShot 2026-09-26 at 13.43.00@2x.png

    Live view
    /Users/steve/Library/Application Support/CleanShot/media/media_6Mb1QosQCc/CleanShot 2026-09-26 at 13.43.14@2x.png
assignee: steve
priority: medium
task_status: review
tech: null
---
I can still see one slight text glitch between Read and Live modes

## Read
![CleanShot 2026-09-26 at 10.38.42@2x.png](attachments/2026/09/01M3EHB4SW182EK65MYYMPWSN5/CleanShot-2026-09-26-at-10.38.42@2x.png)

## Live
![CleanShot 2026-09-26 at 10.39.53@2x.png](attachments/2026/09/01M3EHB4SW182EK65MYYMPWSN5/CleanShot-2026-09-26-at-10.39.53@2x.png)
