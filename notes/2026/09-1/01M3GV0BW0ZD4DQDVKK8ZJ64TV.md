---
id: 01M3GV0BW0ZD4DQDVKK8ZJ64TV
created: 2026-09-27T07:06:55.232098Z
updated: 2026-09-27T07:29:33.049481Z
type: task
title: 'Every group in the role editor carries a type pill: Security group, Distribution list or Mail-enabled security'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 769
sprint: ss8v7d0
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Found reviewing the role editor after COM-764, 2026-09-27.

Since COM-764, the role editor's group lists badge distribution lists and mail-enabled security groups, but not plain security groups. "No pill" has to be read as "security group", which is easy to miss and only true while nothing else can appear there.

## What people see

- **Every group** in both lists (groups you can map, and groups already mapped) carries exactly one type pill:
  - **Security group**
  - **Distribution list**
  - **Mail-enabled security**
- Each type has its own colour, used the same way in both lists. The existing *On-premises*, *Gone from the tenant* and *Refused* pills keep their meanings and sit after the type pill.
- Pills never truncate (Screen conventions); the group name yields instead.

## Notes

- Frontend only. `ListBadge` in `access/RoleDetailPage.tsx` becomes a type badge for all three kinds. Use `GROUP_TYPE_LABELS` from `directoryLabels.ts`, or a role-editor wording beside it, so the Groups tab and the editor don't drift apart.
- Check the Groups tab uses the same colours for the same kinds. If it doesn't, pick one scheme and apply it in both places.

**Done when:** every row in both panes of the role editor shows one type pill, confirmed by a test covering all three kinds.