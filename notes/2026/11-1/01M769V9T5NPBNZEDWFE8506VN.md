---
id: 01M769V9T5NPBNZEDWFE8506VN
created: 2026-11-11T21:57:26.469263Z
updated: 2026-11-12T07:39:59.036511Z
type: task
title: A feed's first run after the old readers retire is held for review, because the carried history has no account
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1740
sprint: spsp226
comments:
- id: 01M76FASR5YK4S6858JCEK221D
  author: Steve Vine
  at: 2026-11-11T23:33:17.1895Z
  text: |-
    Code done, merged in PR #1737 (no migration).

    What changes: a feed's first run over history carried from a retired reader now counts that history as open. Closing 192 or 164 of about 4,970 therefore goes straight through, and closing most of them is still held.
    - The carried repositories and images take on the feed's part as their own, so later runs count normally.
    - Side effect: a repository whose findings Aikido now reports as all solved closes them too. Before this, they would have stayed open for good.

    Choice (from the Done-when): fix it in the run, not with a data migration.
    - Before counting what's open, a run gives the targets it reads, which have no scope, its own scope.
    - A carried target belongs to one repository rather than to the account, so a migration would have had to guess which part it belongs to.
    - This also covers any later carry, and nothing in it names a service.

    Test: test_feed_carried_targets.py. Two carried repositories with no scope and 52 open findings; the run closes 12 and is applied, not held. Without the fix, the same test is held with "close 10 of 0".

    Still to do, after the staging deploy, by me: a held run blocks every later run of that feed. So on each of the two held Aikido runs ("Issues in code repositories" and "Issues in containers") I'll press Discard, then Run now, and check each applies without being held, with about 4,970 open before. I'll add the result here.
- id: 01M77B5Z5WR48EN19MVW42V3DA
  author: Steve Vine
  at: 2026-11-12T07:39:59.036296Z
  text: |-
    Pre-UAT on staging (7ff9a75d): Passed.

    - The two held runs had already been applied at 23:02 UTC on 11 Nov, before this deploy, closing 192 and 164. Nothing was left to discard.
    - Each feed then ran again on the new build (I started one at about 01:06, and the schedule ran again at 07:09). Every run since has been applied with nothing held:
      - Issues in code repositories, 07:09: applied, 5,157 open before, 7,690 read.
      - Issues in containers, 07:09: applied, 1,751 open before, 28,082 read, 17,976 still waiting for their parts to be given companies.
      - Issues in clouds, 03:54: applied, 2,289 open before.
    - The open count is now the real figure, not 0. Containers count 1,751 rather than ~4,970 because most container findings belong to parts not yet given a company, and those don't count.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the COM-1716 staging check on 2026-11-11.

**What happens:** when COM-1716 moved the old Aikido reader's repositories and container images onto the Aikido feeds, the first time each of those feeds then ran, it was held for review: "It would close 192 of 0 open findings" (code repositories) and "164 of 0" (containers). In fact about 4,970 findings are open on each, so closing 192 or 164 (findings Aikido now reports as solved since the last read at 06:10) is an ordinary run. No vulnerability would be added, fixed or reopened, and no duplicates are made: the run lands on the carried repositories and images.

**Why (technical):** the carry left those targets with no scope. A feed counts what's open only on targets with its account's scope, so it saw 0 open, and the hold rule read the closes as nearly everything. When the run is approved, each target takes its account's scope and later runs count normally, so it only happens once.

**Where it matters:** staging, and any company that had a feed set up while the old reader was still running. Production has no Aikido feeds yet, so the history there stays as history.

**Done when:**
- Carried history is given the scope of the feed account that reads it: a data migration for rows already carried, and the carry itself for any still to come. Alternatively, the open count also includes the feed's targets that have no scope. Choose one and say why in the PR.
- On staging, the two held Aikido runs are dealt with (approved, or replaced by a fresh run), and the next run of each is applied without being held, showing about 4,970 open before.
- A test covers a carried target with no scope followed by a feed run that closes a few findings and isn't held.