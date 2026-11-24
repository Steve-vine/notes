---
id: 01M86JNHK8T4DPCGXTN56BFCXE
created: 2026-11-24T10:47:16.840179Z
updated: 2026-11-24T15:21:19.418445Z
type: task
title: A restore soon after a failed one goes ahead, and the recovery list shows each copy's full version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2140
sprint: szwetpq
comments:
- id: 01M86P6Z3C8HCBCKME38XFY871
  author: Steve Vine
  at: 2026-11-24T11:49:13.452537Z
  text: |-
    Merged: #2124, de82a9914, 24 Nov 11:48 GMT. No migration, no API change. Not on staging yet: the sprint deploys together.

    Built:
    1. A restore straight after a killed one goes ahead. The killed restore's leftover record stops counting as running once the sweep has settled it. Unsettled restores, and anything when the database can't be read, still count.
    2. Before going offline, a restore checks for work that stopping would never stop: an access change in flight, a copy on the backup worker, or Compass being unable to check. If it finds any, it refuses at once and names it, and Compass stays online. Ordinary work isn't refused, because stopping stops it. The check inside maintenance remains as the safety net.
    3. The recovery `list` shows the full version and a new schema column, at any terminal width. The runbook's example output is updated to match.

    Tested: a failing test first reproduced the rehearsal's exact message. A restore started straight after a killed and settled one now gets through stopping in under 3 seconds and finishes. A genuinely running access change or copy still refuses at once, without going offline. 173 maintenance, restore, recovery and Keep audit logs tests pass, and so does the full CI suite.

    Known limit: a copy killed with its pod still blocks restores for 15 minutes, though the restore now refuses at once instead of going offline first. A follow-up could settle killed copies the way killed restores are.

    Couldn't check: a real killed pod in a cluster (tests only).
- id: 01M872BAST87B645H9NAA8J6ZN
  author: Steve Vine
  at: 2026-11-24T15:21:19.418245Z
  text: |-
    Pre-UAT pass, 24 Nov 2026, staging 0234a65f3.

    Couldn't check on staging, by design, part 1: a restore straight after a killed one goes ahead, and refuses at once if work is really running. Both need restores, and killing a restore, on staging's shared data. Not done.

    Couldn't check on staging, by design, part 2: the recovery list shows the full version and schema. The recovery command runs as a cluster Job, which I'm not to run.

    Not seen in the rehearsal either: COM-2124 ran on e034eaeed, before this fix (de82a9914). Its logs show the defect this task fixes. Rely on the build's tests (173 maintenance, restore, recovery and Keep audit logs tests) until a scratch rehearsal at 0234a65f3 or later.

    On staging: Admin ▸ Backups listed BKP-1's full version, "staging-20261124-1443". That's the screen, not the recovery list.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Two small fix-forwards found by the COM-2124 rehearsal, on COM-2116/2118 and COM-2120.

**Chain:** independent.

**1. A restore within 15 minutes of a killed one takes Compass offline for 5 minutes, then refuses.**
After a restore's worker was killed, the next restore put Compass into maintenance, waited 5 minutes, then refused with "Background work wouldn't stop (restore_backup)". The dead pod's record counts as running for 900 seconds, even though the sweep has already settled that restore as failed.

Done when:
- A restore whose record the sweep has settled (failed, or finished after the swap) no longer counts as running work, so the next restore can start straight away.
- Before going into maintenance, a restore checks for work that really is still running, and refuses at once, saying what's running, rather than taking Compass offline for 5 minutes first.
- A test kills a restore and starts another within a minute.

**2. The recovery `list` command cuts the version column** to `main-20261124-`, so copies from different builds look the same.

Done when: the full version (and schema version) shows, at any terminal width, and a test checks it.