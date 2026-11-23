---
id: 01M84Y0F742W7XJ72GMVA1ZZJE
created: 2026-11-23T19:27:00.324161Z
updated: 2026-11-23T19:27:44.178181Z
type: task
title: Backup and restore is proved end to end on a scratch Compass — all three options and a complete failure, timed, with nothing touching staging's or production's data
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2124
sprint: szwetpq
blocked_by:
- 01M84XYPVZG3CMTX5BH2SX7FD7
- 01M84XZ0MTCM83EZFJ91RP6ZDY
- 01M84XZQ02JZCV60Z82NZXPE29
assignee: steve
label:
- chore
priority: high
task_status: todo
---
ADR 0169. The last task in the sprint: nobody should find out whether this works during an incident.

**Chain:** independent (a test run and its write-up).

**Do**, on a scratch Compass with realistic data, in its own namespace on g5, with **outbound integrations and real mail off**:

1. Take a copy, then make changes: edit and delete records, approve and run an access change, cancel an account deletion, revoke a token, place a legal hold, delete evidence.
2. **Everything**: restore, and confirm the data matches the copy and the logs went back too.
3. **Keep audit logs**: repeat, and confirm the logs, legal hold and revocation survived.
4. **Selected records**: put back one deleted risk and one changed document.
5. **Complete failure**: delete the database and wipe Valkey, then recover using only the runbook.
6. **Kill it part way**: stop a restore at each step, and confirm Compass comes back as it was.

**Done when**

- All six pass, with what was seen recorded on this task.
- **In every full restore, no access change or account deletion ran** until an Admin chose it, confirmed by the attempted outbound calls being zero.
- The time for a copy, a restore and a complete recovery is written in the runbook, with the database size it was measured at, and an estimate for production's size.
- The scratch namespace is removed afterwards.

**Not in this task:** running a restore on production. Whether and when to rehearse that is Steve's call. The result can support the SOC 2 restore-test evidence (R-1131) only if it's run against production's data or Steve and the auditor accept it, so don't claim it as that evidence.