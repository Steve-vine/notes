---
id: 01M4ZQGV2PPZXFHNG49PZ1FRK5
created: 2026-10-15T12:10:19.094533Z
updated: 2026-10-15T13:13:59.11039Z
type: task
title: A request whose run is killed partway still records what it changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 973
sprint: s192kdq
comments:
- id: 01M4ZV59XNBGJGR0B6AMQ6EJMV
  author: Steve Vine
  at: 2026-10-15T13:13:55.381254Z
  text: |-
    Done: PR #964, merged as ea392e5a.

    Each change a request run makes in a directory is now recorded in its own transaction, committed straight after the change, instead of when the run commits per person. A run killed partway leaves the record of what it had already done. The request still shows Executing until the 30-minute sweep fails it with Retry.

    Test test_a_run_killed_partway_keeps_the_record_of_what_it_changed kills a leaver after its group removals. It fails on the old code. The 16 integration test files that read the recorded changes pass (400 tests), and CI is green.

    Recert removals, which make one change and save straight away, are unchanged. Not yet on staging.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found on staging 2026-10-15 (Steve), leaver #68 for Abu Darby.

## What happens

The first run of the leaver was killed (out of memory, COM-970) after it had already:
- signed Abu out;
- removed him from AccessXD SSO (Test), 15Five Users and M365 - F3 Basic.

Those changes are real in the tenant, but the request's history doesn't show them. Compass records what a run changed only when the run finishes, so a killed run takes its record with it. The retry found the groups already gone and recorded nothing for them either. So the request's history, and the audit trail behind it, never say Compass removed them.

## What should happen

Each change Compass makes in a directory is recorded as soon as it's made. A run that dies afterwards leaves the record behind, and a retry carries on from it.

## Notes (technical)

- `access_execute._ledger` adds `AccessChange` rows to the run's session, which is committed once at the end (or on failure).
- Write each ledger row in its own short transaction straight after the directory write, so it survives the run's death. Keep the in-run behaviour the same.