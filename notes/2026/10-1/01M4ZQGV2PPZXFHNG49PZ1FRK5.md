---
id: 01M4ZQGV2PPZXFHNG49PZ1FRK5
created: 2026-10-15T12:10:19.094533Z
updated: 2026-10-15T12:16:41.530269Z
type: task
title: A request whose run is killed partway still records what it changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 973
sprint: s192kdq
assignee: steve
label:
- bug
priority: medium
task_status: active
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