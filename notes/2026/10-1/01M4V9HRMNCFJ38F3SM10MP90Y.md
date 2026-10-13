---
id: 01M4V9HRMNCFJ38F3SM10MP90Y
created: 2026-10-13T18:49:11.573092Z
updated: 2026-10-13T19:00:00.521703Z
type: task
title: Access Control ▸ Admin gains Membership rules — "If in group … then drop group …", each rule switched on or off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 947
sprint: s192kdq
blocked_by:
- 01M4V9H6K7M4H479HV0DB006NN
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of the POC Tweaks sprint. Needs the decision record (COM-946). This is the card where rules are written and kept. On its own it changes nobody's groups: the three tasks after it make the rules take effect, and they go to staging together.

## What people see

- **Access Control ▸ Admin gains a "Membership rules" card**, below Role mappings, for the current company.
- **Each rule is one line that reads as a sentence:** If [condition] [group] then [action] [groups].
  - **Condition:** "in group" or "not in group".
  - **The group it looks at:** one group, picked from a list.
  - **Action:** "add group" or "drop group".
  - **The groups it adds or drops:** one or more, picked from a list.
- **The card says what "in group" means**, in a line under it: the person's roles give them that group, or they have been given it individually. *(Decided by Steve, 2026-10-13.)*
- **Add rule** puts a new, empty line at the bottom to be filled in. A rule is saved when all four parts are filled in.
- **Each rule has a checkbox to switch it on or off.** A new rule starts on. A rule that is off is kept, greyed, and does nothing.
- **A rule can be changed or deleted.** Deleting asks first.
- **The order of the rules does not matter**, so there is nothing to move up or down. They are listed in the order they were added.
- **The lists offer groups by name, searchable**, the way a role's group list does:
  - The condition offers any group Compass can govern, since a person can be given one individually without any role naming it.
  - "Drop group" offers the groups the company's roles give or another rule adds.
  - "Add group" offers any group a role could be given. A dynamic group is not offered.
- **The card warns about rules that fight:** one rule adding a group that another drops (drop wins, and the card says which two). A rule that adds or drops the same group its condition looks at is refused.
- **A rule whose group has left the directory is marked** and does nothing until it is repaired or deleted.
- **Who:** whoever can change the rest of this tab (Access write). Every change is in the activity record.

## Notes (technical)

- **Storage.** `membership_rules`, company-scoped: `condition` (`in_group` | `not_in_group`), `condition_group_id`, `action` (`add_group` | `drop_group`), `enabled` (default true), timestamps and actor. `membership_rule_groups` for the action's groups (rule id, group id). Strings with check constraints, not Postgres enums. Group ids are the mirror's (`directory_groups.id`); no foreign key that would stop the mirror dropping a group, so a vanished group is found by the join coming back empty. Next migration number at the time; revision id 32 characters or fewer.
- **API.** `/api/v1/membership-rules`: list (`?company=`), create, update, delete, under `require_access_business_roles` and `require_writable_company`. The response carries each group's name and whether it is still in the directory, and any conflicts between enabled rules, worked out on the server. Regenerate `schema.d.ts`.
- **Validation on save** follows COM-946 points 10 and 11: which groups each part may name, the privileged-group rule for "add", no dynamic group in an action, no rule acting on its own condition group.
- **Pickers.** Reuse the group picker a role's group list uses (`RoleDetailPage` / `RolesPage`), not a new one. The condition's list is the whole of what is governable and may be long: it must search on the server, not load every group.
- **Audit.** Both tables join `_AUDITED_TABLES`; the label is the rule as its sentence.
- **Screen.** `access/MembershipRulesSection.tsx`, added to `SECTIONS` in `AccessAdminPage.tsx` after Role mappings. The on/off `Checkbox` needs `w="fit-content"`; a table needs a no-sort comment. Four controls and a checkbox on one line will not fit a narrow window: let the line wrap, and look at it in a real browser.
- **This task raises no request.** What a rule change does to people is the catch-up task; until that lands the card says under itself that rules are not applied yet. Remove that line in the catch-up task.
- **Tests.** Backend: create, change, switch off, delete; each refusal; conflicts reported; per company; needs Access write; a vanished group marks its rule. Front end: adding and filling a rule, the on/off checkbox, the conflict warning, the delete prompt.

**Done when:** on staging an Access admin adds "If in group E3 then drop group F3", switches it off and on, changes it, deletes it, and finds the rules still there after a reload.