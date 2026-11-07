---
id: 01M6TPF1VABNMCXDGT6CEDR99B
created: 2026-11-07T09:47:03.402958Z
updated: 2026-11-07T10:49:37.807202Z
type: task
title: 'Two collection slips seen on SOD.9: a check filed the same capture twice, and a yes/no setting was sent to GitHub as "True" rather than "true"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1629
sprint: s5khbev
comments:
- id: 01M6TT1KEV6Z5JEC36DFCQY5NT
  author: Steve Vine
  at: 2026-11-07T10:49:36.987656Z
  text: |-
    **Done: merged to main in PR #1639. It reaches staging with the rest of sprint 107.**

    **1. The two captures weren't a race.** "Protected status of branches" reads two repositories. Compass filed one capture per read, both under the same GitHub account.
    - **Consequences:** a rule could only ever judge one repository. Each run also compared one repository's answer with the other's, so it kept filing new evidence when nothing had changed.
    - **Now:** each account gives one capture per collection, however many reads the check has.
      - When there are several reads, each item says which one it came from. The evidence page and a rule's failures can then tell two repositories' "main" apart, e.g. "main · /repos/Moneypenny-Development/docs/branches".
    - **No data clean-up needed:** the next collection files one combined capture, which becomes the latest. The old pair stays in the history.

    **2. "True" is now sent as "true".** A true/false setting reaches the service as `true`/`false`, so GitHub's rulesets read includes organisation-level rulesets. Checks already saved with "True" are corrected every time they run, so nothing needed changing in the database.

    **To look at on staging:** on SOD.9, use Collect now on "Protected status of branches". You should get one new capture, listing both repositories' branches, each tagged with its repository.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found while looking into Steve's SOD.9 report on staging (2026-11-07, Test Company, GitHub integration 37e2f978).

## 1. One collection filed two captures

The check "Protected status of branches in each repository" has two filed captures with the same time (2026-11-07 09:27:37.947429 UTC), the same source (`collection:0ee458a7…`) and 1 item each. It reads 2 repositories. Either each read filed its own capture, or the first-capture approval and a collection both filed at once. The Evidence register, audit packs and the rule should see one capture per collection per account.

Done when:
- One collection of a check gives at most one filed capture per account, however many reads it has. It holds every read's items, as `latest_filed` assumes.
- Approving the first capture and a "Collect now" (or the schedule) racing can't both file. Use the existing unique key or lock on (check, account, collection run).
- A test reproduces the two-read case and the race.
- The duplicate on staging is removed (the newer of the two), recorded in the activity log.

## 2. A yes/no setting reaches the service as "True"

The rulesets reads carry `includes_parents: "True"`. Python's True was turned into text, but GitHub expects `true`, so organisation rulesets may be left out. The params come from Polaris's design (JSON true) and become text in `core/collection/client.py` (`str(v)`).

Done when:
- A true/false setting is sent as `true`/`false`, and numbers as written. This applies where a check's reads are saved and where the client builds the query.
- Existing checks with "True"/"False" are corrected (data fix or on read).
- A test: a read with `{"includes_parents": true}` sends `includes_parents=true`.