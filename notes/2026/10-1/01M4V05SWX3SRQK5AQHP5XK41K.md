---
id: 01M4V05SWX3SRQK5AQHP5XK41K
created: 2026-10-13T16:05:22.461128Z
updated: 2026-10-13T17:14:36.857936Z
type: task
title: The joiner and mover forms have three Additional roles boxes, on their own line under Primary role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 940
sprint: s192kdq
comments:
- id: 01M4V1H109DVB7Z0CM60MAC876
  author: Steve Vine
  at: 2026-10-13T16:28:58.761188Z
  text: |-
    Merged to main (PR #935, 2026-10-13). Not on staging until all four POC Tweaks tasks are in review.

    What to look at:
    - Access Control ▸ Requests ▸ raise a Joiner. Primary role is on a line of its own, full width, with "Created in …" still under it. Below it are three boxes, each labelled Additional roles.
    - Pick a role in the second box: it is no longer offered in the first or third. Pick it as the Primary role instead and it leaves the box it was in.
    - Raise a joiner with a role in each of the three boxes. The request shows all three under Additional roles, as one list.
    - Raise a Mover for somebody who already holds additional roles: they open in the first box. Keep puts a role back in the first box too.
    - Open a pending joiner or mover as an approver and edit it: the same four boxes.
    - The leaver form is unchanged. It has no role boxes.

    Different from the task text:
    - Primary role takes the full width of its line, not the width of one Additional roles box. The mover's placeholder ("The role that decides where their account lives") and the "Created in" line do not fit in a third of the window.

    Not looked at in a real browser by me. On a narrow window the three boxes stack into one column.

    Technical: front end only, in JoinerRoleFields.tsx, which all four uses share. The three boxes are joined into additional_business_role_ids as the one box was, so no API, schema or migration change. Which box a role sits in is the form's own state and is not stored. Each box has its own accessible name ("Additional roles 1", "2", "3"); existing tests now name the first box.
- id: 01M4V44JXSJ81KD1193JX5AWJW
  author: Steve Vine
  at: 2026-10-13T17:14:36.857616Z
  text: 'Update to the note above: since looked at in a real browser (headless Chromium, stubbed data). Primary role fills its line, the three Additional roles boxes sit under it at equal widths, a box grows as roles are added to it, and at narrow width the three stack into one column.'
assignee: steve
label:
- improvement
priority: medium
task_status: review
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