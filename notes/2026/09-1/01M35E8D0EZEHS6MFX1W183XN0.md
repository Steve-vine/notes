---
id: 01M35E8D0EZEHS6MFX1W183XN0
created: 2026-09-22T20:52:28.30279Z
updated: 2026-09-22T21:16:40.044773Z
type: task
title: A recertification test forges a wrong container id that is sometimes the right one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 743
sprint: s3nfes0
comments:
- id: 01M35FMPQC6DSXXNVWZJYH9BDX
  author: Steve Vine
  at: 2026-09-22T21:16:40.044594Z
  text: 'Done — PR #749, merged to main. The "container must be in the company" check now posts a fresh `uuid4()` rather than the real id with its last character swapped, which was the real id one time in sixteen. No other test forged an id that way. Nothing to smoke-test.'
assignee: steve
label:
- bug
- chore
priority: medium
task_status: review
---
`tests/test_container_recert.py::test_a_container_schedule_needs_the_inventory_permission` checks that a container schedule must name a container in the company by posting the real container id with its last character replaced by `0`. One time in sixteen the real id already ends in `0`, the "wrong" id is the right one, the create succeeds with 201 and the test fails on `assert 201 == 422` (seen on PR #748's first CI run, 2026-09-22; passes in isolation).

Fix: use a fresh `uuid4()` for the foreign id. Same pattern searched for elsewhere in the tests.