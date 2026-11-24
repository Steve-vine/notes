---
id: 01M85TY7E1Y89T258PPKH1BMGQ
created: 2026-11-24T03:52:35.521407Z
updated: 2026-11-24T17:35:31.169181Z
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