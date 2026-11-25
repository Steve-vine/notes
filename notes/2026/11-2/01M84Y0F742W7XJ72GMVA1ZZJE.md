---
id: 01M84Y0F742W7XJ72GMVA1ZZJE
created: 2026-11-23T19:27:00.324161Z
updated: 2026-11-25T09:17:31.757506Z
type: task
title: Backup and restore is proved end to end on a scratch Compass — all three options and a complete failure, timed, with nothing touching staging's or production's data
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2124
sprint: szwetpq
blocked_by:
- 01M84XYPVZG3CMTX5BH2SX7FD7
- 01M84XZ0MTCM83EZFJ91RP6ZDY
- 01M84XZQ02JZCV60Z82NZXPE29
comments:
- id: 01M86JQBMAMHNP5PATJXAZGY9A
  author: Steve Vine
  at: 2026-11-24T10:48:16.266268Z
  text: |-
    Rehearsal done on the final build (e034eaeed, image main-20261124-0747), 24 Nov. The scratch Compass ran in its own namespace on g5, cut off from the internet, with a fake Microsoft tenant recording every outbound request. Its database was 1.38 GB (production's is 1.35 GB) with 3.47M activity entries. The namespace and its volumes are deleted. Staging was untouched. Runbook timings: PR #2122, merged. Evidence: ~/compass-uat/backup-and-restore/COM-2124/ (start with logs/phase-b-summary.md).

    Results:
    1. Copy, then changes: PASSED. A copy takes 20 s.
    2. Everything: PASSED in 2 min 7 s. 522 of 529 tables matched the copy exactly (the other 7 hold the restore's own records), and logs went back. During the hold there were 0 outbound requests and 0 mail; the access change ran only after release.
    3. Keep audit logs: PASSED, but took 7 min 27 s, about 5 min 40 s of it carrying 3.47M activity entries forward. The logs, legal hold and revocation survived, with 0 outbound requests during the hold.
    4. Selected records: the records came back correctly (RSK-1213 kept its number, logged "Put back from BKP-8"), but the screen fails at this size (COM-2139).
    5. Complete failure: PASSED using only the runbook, 3 min 10 s from "database gone" to an Admin at the review, restoring a copy from the older build (upgrade step included). 0 outbound requests during the hold.
    6. Kill part way: PASSED. Before the swap, Compass came back exactly as it was. Just after the swap, the restore finished and Compass came up on hold.

    No full restore sent a single outbound request or mail while on hold.

    Production estimates (in the runbook): complete recovery 10–15 min, Everything 4–6 min, Keep audit logs 15–20 min and growing with the activity log, copy under 1 min.

    Defects found, fixed forward in this sprint: COM-2138 (the review shows "?" instead of the person's name), COM-2139 (a put-back takes about 3 min, and the screen shows an error after 60 s for one that worked), COM-2140 (a restore soon after a killed one goes offline for 5 min and then refuses; the recovery list cuts the version). Earlier: COM-2129 (older S3 stores, merged) and COM-2130 (decision numbers clash, backlog).

    For Steve: Compass has no way to delete a risk, so the rehearsal had to mark one deleted directly in the database to test putting it back. Whether risks should be deletable is a product question outside this sprint.

    Not this task: a restore on production. The rehearsal is not SOC 2 restore-test evidence unless you and the auditor accept it.
assignee: steve
label:
- chore
priority: high
task_status: done
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