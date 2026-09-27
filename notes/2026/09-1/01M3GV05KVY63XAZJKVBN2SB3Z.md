---
id: 01M3GV05KVY63XAZJKVBN2SB3Z
created: 2026-09-27T07:06:48.827569Z
updated: 2026-09-27T07:06:59.314129Z
type: task
title: 'A mapped group that can no longer be mapped says so in the role editor: rule-based membership, or now grants admin roles'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 768
sprint: ss8v7d0
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Found reviewing the role editor after COM-764, 2026-09-27.

A group is checked when it is mapped to a business role. After that, two things can change in Entra that make the mapping one Compass can no longer act on:
- **Membership switched to rule-based (dynamic).** The rule now decides who is in it, and Compass can't add or remove anyone.
- **Made role-assignable.** The group now grants Entra admin roles, and changes to it need an Access Admin's approval (ADR 0061 §5).

Today the role editor's list of mapped groups shows neither. The group looks like any other. The first sign is a joiner's request noting "groups refused (not writable)".

No mapped group on staging is in either state today (63 mapped, all assigned security groups, none role-assignable).

## What people see

- **In the mapped groups list**, such a group carries a pill that says why:
  - **Rule-based membership**, with the explanation: *"Its membership is now set by a rule in Entra, so Compass can't change it. Unmap it, or map the groups the rule draws on."*
  - **Grants admin roles**, with the explanation: *"This group now grants Entra admin roles. Changes to it need an Access Admin's approval."*
- The pill sits beside the type pill, like *On-premises* and *Gone from the tenant*, and never truncates.
- **Actions:** people who manage business roles, plus the role's owner, get a row like COM-766's: *"Sales maps a group whose membership is now rule-based: Finance Users. Unmap it."* It closes when the mapping is removed. Not raised for the admin-roles case, which is still a valid mapping; that one only gets the pill.

## Notes

- The role's `groups` already carry `membership_type` and `is_assignable_to_role`, so this is the frontend plus one action source. The COM-766 source in `core/actions/access.py` is the model.
- Execution is unchanged: `_writable_group_ids` already refuses a non-governable group at the write, with a note.

**Done when:** a role mapping a group later switched to dynamic shows the *Rule-based membership* pill and raises the action. A group made role-assignable shows *Grants admin roles*. Covered by frontend and backend tests.