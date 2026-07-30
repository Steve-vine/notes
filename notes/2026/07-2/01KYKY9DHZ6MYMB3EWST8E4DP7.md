---
id: 01KYKY9DHZ6MYMB3EWST8E4DP7
created: 2026-07-28T08:43:31.775315Z
updated: 2026-07-30T13:16:42.066177Z
type: task
title: Sticky encryption bug
project: 01KY6W9951TW0904DT0GGJVGE7
number: 375
order: 1.0625
sprint: segj1dz
comments:
- id: 01KYSF6NTGXXFC1DM52J3GA0VN
  author: Steve Vine
  at: 2026-07-30T12:15:19.888578Z
  text: |-
    Fix up for review: PR #367 (branch not-375-sticky-encryption-wipe).

    Root cause: selecting the locked sticky makes the properties panel acquire the shared doc buffer, which loads the locked placeholder body (""). The workspace unlock dialog only sets backend session state (no file write, no note-changed event), so that buffer stayed stale — and deselecting released the last reference, whose flush wrote unconditionally, sealing the empty body over the just-unlocked note. Workspace-only because the note pane already reloads its handle after unlock.

    Fix: flush() now skips the write when the buffer is clean (keepLocal forces), and the workspace's unlock/lock/encrypt paths reload any live handle via a new reloadIfOpen(). Regression tests added (first frontend tests to mock the Tauri layer).

    Note: the wiped sticky's contents are not recoverable from the app, but versions saved before the wipe should still be in git-sync history.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
If I double click an encrypted Sticky to unencrypted it and view the contents, then click off it, the content disappears, only the title is left.  Then when editing it again, it starts off as a blank note. This only seems to be the case when editing it on the Workspace, I haven’t been able to replicate the behaviour anywhere else.