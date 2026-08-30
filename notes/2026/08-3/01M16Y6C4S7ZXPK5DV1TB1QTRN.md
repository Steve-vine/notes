---
id: 01M16Y6C4S7ZXPK5DV1TB1QTRN
created: 2026-08-29T14:18:54.974172Z
updated: 2026-08-30T16:03:32.493303Z
type: task
title: Issue with attachments
project: 01KY6W9951TW0904DT0GGJVGE7
number: 409
sprint: segj1dz
comments:
- id: 01M1748G8YKSZJR61SFC5DZYK3
  author: Steve Vine
  at: 2026-08-29T16:04:51.09823Z
  text: |-
    Root cause found — not a storage or resolve problem at all. WebKit now drops a plain cross-scheme <img> before the notuvia-attachment protocol handler is ever called, so every embedded attachment fails identically regardless of its path. Confirmed with a WKWebView harness: same-scheme images load, fetch() on the same URL reaches the handler, and a plain cross-scheme image never does.

    Fix (PR #401, ADR 0056): request attachment images with crossorigin="anonymous" and have serve_attachment answer with Access-Control-Allow-Origin. Neither half works alone — measured both ways. Our code, Tauri and wry are all unchanged since before the breakage; what changed is WebKit, which ships with the OS.
assignee: steve
label: null
priority: medium
task_status: done
---
![CleanShot 2026-08-29 at 15.13.59@2x.png](attachments/2026/08/01M16Y6C4S7ZXPK5DV1TB1QTRN/CleanShot-2026-08-29-at-15.13.59@2x.png)

After pasting in an attachment it's showing as missing, yet I can see it at the path specified.