---
id: 01M4ZQGG86MDFHPVZ7MFPQPNNZ
created: 2026-10-15T12:10:08.006629Z
updated: 2026-10-15T12:10:23.178116Z
type: task
title: A leaver's list changes reach Exchange before the account is deleted
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 971
sprint: s192kdq
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found on staging 2026-10-15 (Steve), leaver #68 for Abu Darby, after COM-970.

## What happens

A leaver can ask for the account to be deleted straight away ("delete after 0 days"). The run does that in the same pass. But a run sends its distribution-list membership changes to Exchange in one batch at the **very end**, after the delete. By then Exchange may no longer hold the person: Graph removes a cloud account at once, and here the licence had already gone. So taking them off the list fails and the request ends *Failed*.

## What should happen

The leaver's list changes go to Exchange before the account is deleted. The delete stays last, so what the leaver took away is recorded first.

## Notes (technical)

- `access_execute._execute_subject` calls `_flush_list_writes` after `_dispatch_kind`. `_execute_leaver` calls `_delete_account` when `delete_after_days == 0`.
- Flush the queued list writes inside `_execute_leaver`, after the list rights and before the leave date and the delete. The leave date stays the last thing that can fail (COM-868).