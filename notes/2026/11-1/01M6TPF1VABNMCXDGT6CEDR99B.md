---
id: 01M6TPF1VABNMCXDGT6CEDR99B
created: 2026-11-07T09:47:03.402958Z
updated: 2026-11-07T09:47:06.712818Z
type: task
title: 'Two collection slips seen on SOD.9: a check filed the same capture twice, and a yes/no setting was sent to GitHub as "True" rather than "true"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1629
sprint: s5khbev
assignee: steve
label:
- bug
priority: medium
task_status: todo
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