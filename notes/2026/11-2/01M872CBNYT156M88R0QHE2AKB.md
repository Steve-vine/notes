---
id: 01M872CBNYT156M88R0QHE2AKB
created: 2026-11-24T15:21:53.086545Z
updated: 2026-11-24T15:21:55.278951Z
type: task
title: When a put-back finishes, the compare list shows the records as Same at once, not Missing for another 25 seconds
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2144
sprint: szwetpq
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Fix-forward on COM-2139/COM-2122, found in the pre-UAT pass on staging 0234a65f3 (screenshot `~/compass-uat/backup-and-restore/COM-2139/03-finished-list-still-says-missing.png`).

**Chain:** independent (frontend only, unless the fix needs an API change).

**What happened**

In Open to compare, the Admin ticked a deleted technology asset (AST-66) and its installed software, then chose Put back and stayed on the screen. The banner said "Last put-back: 2 records put back from BKP-1", but for 10–25 seconds afterwards the counts still read "Technology asset 1 missing" and the row still said Missing. The server already answered Same. An Admin could think it failed and tick it again.

**Done when**

- As soon as the banner says a put-back has finished, the area counts and every affected row reflect it, without a reload.
- Ticks for records that were put back are cleared, so they can't be put back twice by accident.
- A component test fails on the old behaviour and passes on the new.