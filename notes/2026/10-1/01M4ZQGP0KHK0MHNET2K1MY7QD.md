---
id: 01M4ZQGP0KHK0MHNET2K1MY7QD
created: 2026-10-15T12:10:13.907808Z
updated: 2026-10-15T12:14:34.456663Z
type: task
title: Taking away access from someone Exchange no longer holds counts as done, not a failure
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 972
sprint: s192kdq
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found on staging 2026-10-15 (Steve), leaver #68 for Abu Darby.

## What happens

Removing a person from a list, or taking away a right they hold, fails with "the member is not a recipient Exchange can add: Exchange has no recipient with this id" when Exchange no longer holds them. That happens when their licence has gone, or their account has been deleted. The request ends *Failed*, and retrying gives the same answer for ever.

## What should happen

- **A removal for someone Exchange doesn't hold counts as done:** there is nothing left to take away, and Exchange drops a removed recipient from its lists itself. The outcome says so ("Exchange no longer holds them — nothing to remove").
- **An add** for someone Exchange doesn't hold still fails, as today.
- The same goes for each Exchange write that takes access away: list membership, send as / send on behalf, and shared-mailbox access.

## Notes (technical)

- `set_list_membership.ps1`, `set_list_rights.ps1` and `set_mailbox_access.ps1` each resolve the person by `ExternalDirectoryObjectId`. When none is found on a `remove`, reply ok with an "already so" message, as for "is not a member".
- Only the "no recipient with this id" case. A lookup that errored, or found more than one, still fails.