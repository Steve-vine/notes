---
id: 01M769V9T5NPBNZEDWFE8506VN
created: 2026-11-11T21:57:26.469263Z
updated: 2026-11-11T22:56:54.117362Z
type: task
title: A feed's first run after the old readers retire is held for review, because the carried history has no account
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1740
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found in the COM-1716 staging check on 2026-11-11.

**What happens:** when COM-1716 moved the old Aikido reader's repositories and container images onto the Aikido feeds, the first time each of those feeds then ran, it was held for review: "It would close 192 of 0 open findings" (code repositories) and "164 of 0" (containers). In fact about 4,970 findings are open on each, so closing 192 or 164 (findings Aikido now reports as solved since the last read at 06:10) is an ordinary run. No vulnerability would be added, fixed or reopened, and no duplicates are made: the run lands on the carried repositories and images.

**Why (technical):** the carry left those targets with no scope. A feed counts what's open only on targets with its account's scope, so it saw 0 open, and the hold rule read the closes as nearly everything. When the run is approved, each target takes its account's scope and later runs count normally, so it only happens once.

**Where it matters:** staging, and any company that had a feed set up while the old reader was still running. Production has no Aikido feeds yet, so the history there stays as history.

**Done when:**
- Carried history is given the scope of the feed account that reads it: a data migration for rows already carried, and the carry itself for any still to come. Alternatively, the open count also includes the feed's targets that have no scope. Choose one and say why in the PR.
- On staging, the two held Aikido runs are dealt with (approved, or replaced by a fresh run), and the next run of each is applied without being held, showing about 4,970 open before.
- A test covers a carried target with no scope followed by a feed run that closes a few findings and isn't held.