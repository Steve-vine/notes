---
id: 01M4V06QW340H9SMRTXQSR864A
created: 2026-10-13T16:05:53.155011Z
updated: 2026-10-13T16:24:14.512187Z
type: task
title: A role box with an alt title set in Role mappings shows that title on the joiner and mover forms
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 942
sprint: s192kdq
blocked_by:
- 01M4V05SWX3SRQK5AQHP5XK41K
- 01M4V06B8PH0MWH0FYT9F7FF8Y
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Part of the POC Tweaks sprint. Needs the three boxes (COM-940) and the Role mappings card (COM-941). The filter is the task after this one.

## What people see

- **A box that has an alt title shows it in place of the standard one**, on the new-joiner form, the mover form and the approver's edit of either, for the company the request is for.
- **Primary role** with the alt title "Department" reads **Department (Primary)** followed by the required star: "Department (Primary) *".
- **An Additional roles box** with an alt title shows just that title: "Team", "Location".
- **A box with no alt title is unchanged:** "Primary role" with its star, or "Additional roles".
- **Each box is set on its own**, so one company can title two of the four and leave the others standard.
- **Only the box titles change.** The sentences around them that say "primary role" (where the account will be created, "A joiner needs a primary role", the mover's "Keep … as an additional role"), the summary before raising, the request page and the role pages keep the standard words. All of a person's additional roles are still one list everywhere but the form. *(My call: Steve asked for the forms.)*

## Notes (technical)

- **Where the form gets them.** The titles are per company and every form that shows the role boxes must have them before it draws, or the labels flicker from standard to alt. Put them on what those forms already load (`JoinerFormOut` gains a `role_fields` list: box, title, and room for the filter task's list of offered roles), and check the mover form and `SubjectFieldsEditor` do load it; if either does not, give the boxes one small hook of their own on COM-941's GET.
- **The star is Mantine's `withAsterisk`**, as now. The label text is `<alt title> (Primary)`; do not type an asterisk into it.
- **`JoinerRoleFields.tsx`** takes the four titles. The accessible name follows the visible one ("Department (Primary) for joiner 2"), so a title cannot make two boxes indistinguishable to a test or a screen reader: keep the 1/2/3 in the accessible name when two additional boxes carry the same title or none.
- **Read access.** People who raise requests are not all Access admins; the titles must reach anyone who can open the form, not only those who can write COM-941's settings.
- **Tests.** Titles shown on joiner, mover and approval edit; the "(Primary)" suffix and the star; blank falls back; a second company's titles do not leak.

**Done when:** on staging, with "Department" set on Primary role and "Team" on Additional role 1, the joiner and mover forms read "Department (Primary) *", "Team", "Additional roles", "Additional roles", and a company with nothing set reads as it does today.