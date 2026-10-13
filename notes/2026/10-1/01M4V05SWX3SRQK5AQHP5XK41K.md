---
id: 01M4V05SWX3SRQK5AQHP5XK41K
created: 2026-10-13T16:05:22.461128Z
updated: 2026-10-13T16:05:22.461128Z
type: task
title: The joiner and mover forms have three Additional roles boxes, on their own line under Primary role
assignee: steve
label: improvement
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 940
---
Part of the POC Tweaks sprint. First of four: this one is the layout only. The Role mappings card on the Admin tab, the titles and the filters are the three tasks after it.

## What people see

- **Primary role sits on a line of its own.** Under it, three boxes side by side, each labelled **Additional roles**.
- **The three boxes act the same.** Each takes as many roles as wanted, and every role put in any of them becomes one of the person's additional roles. There is no difference in what an additional role does depending on the box it was picked in.
- **A role is only ever in one box.** Once picked in one it is not offered in the other two. Taking it as the primary role moves it out of whichever box it was in, as it does today.
- **Wherever the two role boxes are today:** the new-joiner form (for each joiner on a request with several), the mover form, and the approver's edit of either.
- **Opening something that already has additional roles** (a mover opens on what the person holds today; an approver opens what was asked for) puts them all in the first box. The mover's **Keep** also puts a role back in the first box. The filter task changes where they land.
- **Nothing else changes.** The request, its summary before raising, the request page and the role pages still read "Additional roles" as one list. What is raised, approved and carried out is the same.
- **The leaver form is untouched.** It has no role boxes: a leaver names a person, not roles.

## Notes (technical)

- **Front end only.** `access/JoinerRoleFields.tsx` is the one component behind all four uses (`JoinerBlocks`, `MoverSections`, `SubjectFieldsEditor` twice), so the change is made once.
- **The API does not change.** The three boxes are joined into `additional_business_role_ids` exactly as the one box is now. No migration, no `schema.d.ts` change. Which box a role sat in is form state and is not stored.
- **Layout:** the `Group grow` of two becomes a primary row and a row of three equal boxes; the placement line and the mover's hint stay under Primary role. Check it at the modal's narrow width.
- **Names for tests and screen readers:** the visible label is "Additional roles" on all three, so each needs its own accessible name ("Additional roles 1", "… 2", "… 3", plus the existing "for joiner 2" suffix). Existing tests find the box by `Additional roles` and will need the new names (`JoinerRoles.test`, `MoverRoles.test`, `JoinerFormFields.test`, `RequestsPage.test`).
- Leave room for the two tasks that follow: each box will take a title and a list of roles it may offer.

**Done when:** on staging a joiner raised with a role in each of the three boxes is created holding all three as additional roles, and a mover opens with the person's current additional roles in the first box.