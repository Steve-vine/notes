---
id: 01M4XJ4PWGA9H6EBM8KZDWJV4N
created: 2026-10-14T15:57:49.840596Z
updated: 2026-10-14T16:53:52.880281Z
type: task
title: A change-access request and the move form can add or remove send as and send on behalf on a list, by name
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 955
sprint: s192kdq
blocked_by:
- 01M4XJ498YCGCKQXZKQ5ZGF54J
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Part of the POC Tweaks sprint; stacks on COM-954. It does for list rights what ADR 0097 and 0098 did for shared-mailbox access.

## What people see

- **Change access** (the ad-hoc request) can name a list and a right: "give Sam send as on Sales UK", or take it away. It is an **exception**: it survives a move, and recertification asks about it. As with list membership (COM-764), any governable list can be named, not only one a role maps.
- **The move form** shows, under the person's lists:
  - the rights they hold directly, each kind on its own line;
  - a diff of what the roles on the form would give and take;
  - **Add** and **Remove** by name, with the same type-to-filter lookup the group and mailbox diffs use.
  A right that comes from a role still on the form is read-only there; it is changed by changing the role.
- **The outcomes and to-dos are COM-954's**: Applied, or Manual with the to-do worded for AD or on-premises Exchange.
- **Refused at raise time** (and again at the write): a right on a Microsoft 365 group, a dynamic group, a room list, or one granted to a group rather than a person.

## Notes (technical)

- **No new request column** if COM-954 put the rights on the subject (`join_list_rights` / `leave_list_rights`). The membership-change request and the mover both ride on them, as `join_mailbox_grants` does.
- **Preview.** The move diff is the server's answer by the rule the run follows. Add `list_rights.preview_mover` beside `mailbox_grants.preview_mover`; the browser computes nothing.
- **Refusals** in `api/v1/access_requests.py`, read from the one rule COM-954 added. Don't copy it.
- **Screen.** Reuse the mailbox diff component if it generalises cleanly. New tables need `SortableTh` or a no-sort comment; any Switch/Checkbox needs `w="fit-content"` (screen-conventions test).
- Check `tests/test_portal.py`'s write-routes allowlist if any new `/api/v1/portal` write route appears.

**Done when:** on staging, a Change access request gives a person send on behalf on a cloud list and it is applied. A move form shows that right as theirs, shows a role's send as coming with the new role, and removes the exception by name. Each outcome appears on the list's page after the next read.