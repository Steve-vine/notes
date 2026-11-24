---
id: 01M85TY7E1Y89T258PPKH1BMGQ
created: 2026-11-24T03:52:35.521407Z
updated: 2026-11-24T19:07:36.927773Z
type: task
title: Restoring the scheduled Postgres backup also brings Compass back on hold, so a rolled-back database can't re-run real account changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2127
sprint: szwetpq
comments:
- id: 01M87A11V147Z9SPKYJXTCB1S2
  author: Steve Vine
  at: 2026-11-24T17:35:31.169007Z
  text: 'Steve, 24 Nov: "Complete COM-2127 now." Steve didn''t pick between the two approaches, so it''s built as the recommended one: a command the operator runs after restoring the scheduled backup and before starting Compass, plus the runbook step. Compass doesn''t try to detect the restore by itself on start-up; that can be added later if wanted.'
- id: 01M87F9P2ZMF2WY81TZC86KHX9
  author: Steve Vine
  at: 2026-11-24T19:07:36.927582Z
  text: |-
    Merged: #2135, bc5c320fc, 24 Nov ~19:00 GMT. No migration and no API change. Runbook: docs/runbooks/restore-scheduled-backup.md, linked from chart/README.md and from the complete-failure runbook. ADR 0177 is Proposed, for Steve to read.

    Built: `recovery hold-after-restore`, a command the operator runs after the platform's own backup has been restored and before Compass starts. It works however the database was restored (CNPG backup, RDS snapshot), through the existing recovery job.
    - It places the same hold as a complete-failure recovery. Every due access change and account deletion waits for an Admin, and every token and privileged role must be confirmed. It clears stale work and sessions from Valkey.
    - It refuses while a deployment is running, while Compass is still running, when the schema is newer, or when the data is clearly too recent for the restore it names (the old database still connected).
    - Running it twice is safe: the second run says a hold is already in place.

    Decision made in the build (ADR 0177, for Steve): an older backup is brought up to date by the command itself before placing the hold, rather than left to the next deployment. Today every production backup predates the hold's own table, so there would otherwise be nowhere to put it.

    Tested:
    - 39 integration tests on real Postgres and Valkey with outbound calls blocked. Three sweeps after the command did nothing, and the review listed everything.
    - A real rehearsal on a throwaway Compass on g5. Its scheduled backup was taken, the live data then ran a leaver change and an account deletion, and the backup was restored into a new database cluster. The command took 17 s, and 10 minutes of watching with Compass running showed 0 outbound connections and 0 mail; neither item ran. After release, exactly the two chosen items ran. The namespace is deleted.

    Couldn't check: the final version of the code in a real cluster (the rehearsal ran the first version; the later review fixes are covered by tests), and a production restore.

    For Steve, production's deployment repo (not changed): to restore the scheduled backup into a replacement cluster, the database address in the deployment settings, the cluster's backup name and the S3 role's trust would all need pointing at the new cluster. Agree that procedure before an incident. CNPG 1.31 also drops the built-in backup method, so the Barman Cloud plugin will be needed.
assignee: steve
label:
- follow_up
priority: high
task_status: active
---
Found while building COM-2120 (ADR 0169 §5, ADR 0171).

**Chain:** probably independent (a command and the runbook). Joins the chain if it needs a migration.

**Why**

Compass's own restores place the hold. Restoring the database platform's scheduled backup (CNPG, nightly, with continuous archiving; the route in COM-730) doesn't. A database rolled back that way makes access changes and account deletions that have since run or been cancelled due again, and the five-minute sweep would run them against real Entra and AD. It would also resend mail and reissue reference numbers. The COM-2120 runbook warns against it, but nothing stops it.

**What should happen**

- After a scheduled-backup restore, and before the app is started, the operator runs one command that places the same hold as a Compass restore. The live data is gone, so it uses the complete-failure version: every token and privileged role to confirm.
- It also clears stale work from Valkey, as `recovery clear-valkey` does.
- The runbook for restoring the scheduled backup (COM-730's write-up) includes the step.

**Done when**

- On a scratch Compass restored from a scheduled backup, with the command run, no access change or account deletion runs until an Admin chooses it, and the review lists every token and privileged role.
- Without the command, the risk is stated plainly in the runbook.

**Steve to decide:** whether Compass should also detect this case itself on start-up (for example, the database's own record of being restored), rather than relying on the operator to remember the command.