---
id: 01M437HPGKZT44Q3Y7GX1KP16Y
created: 2026-10-04T10:32:25.87525Z
updated: 2026-10-04T12:58:34.720796Z
type: task
title: Wrong computer name
project: 01KY6W9951TW0904DT0GGJVGE7
number: 508
sprint: sx287fa
comments:
- id: 01M438DH5VA5X2R5YHTETEP8HD
  author: Steve Vine
  at: 2026-10-04T10:47:37.915222Z
  text: |-
    Done on branch brief-504-crosssync-polish (commit 32e1c3b; lands in the combined sprint PR).

    Cause: the "added on" name was the kernel hostname. This Mac has no fixed HostName (scutil --get HostName → "not set"), so the hostname follows whatever the network hands out — MBP-M314.local at home, Mac.lan on the network you were on when config.json was added on 3 Oct. Same machine: all five entries carry the same install id.

    Fix:
    - machine_name() now asks macOS for LocalHostName (the name set in Sharing, MBP-M314 here), which no network changes. Elsewhere it uses the hostname's first label.
    - The list recognises entries this machine added by install id and shows them under its current name, whatever was recorded.
    - At startup the stored name in meta.yaml is corrected for entries this machine added, so the other laptop stops showing Mac.lan after the next sync. That is one small vault commit, once.

    Decision made on the fly: the name is read once per run, so renaming the Mac shows after a restart.

    Tested: new unit tests for the hostname shortening and the adopt/rename path; the notuvia-core xsync tests pass. Not run in the Tauri app — config.json should read "added on MBP-M314" after updating.
assignee: steve
priority: medium
task_status: done
tech: null
---
One of the files in the sync (config.json) shows the computer name as 'added on Mac.lan'
It was added on this computer the same as the other ones, which all say 'added on MBP-M314', I have no computer called Mac.lan this is incorrect.