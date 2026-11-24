---
id: 01M86JNHK8T4DPCGXTN56BFCXE
created: 2026-11-24T10:47:16.840179Z
updated: 2026-11-24T10:47:28.002558Z
type: task
title: A restore soon after a failed one goes ahead, and the recovery list shows each copy's full version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2140
sprint: szwetpq
assignee: steve
label:
- bug
priority: medium
task_status: active
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