---
id: 01M4V7SFSYK1ZP44G71BVDTDWY
created: 2026-10-13T18:18:27.518407Z
updated: 2026-10-13T19:40:37.650975Z
type: task
title: Additional role 2 and 3 are switched on per company in Role mappings — a box that isn't ticked isn't on the forms
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 944
sprint: s192kdq
comments:
- id: 01M4VCFTQYKRKPKR43XAVXGRQA
  author: Steve Vine
  at: 2026-10-13T19:40:33.917948Z
  text: |-
    Merged to main (PR #939, 2026-10-13). Not on staging until all seven tasks in this batch are in review.

    What to look at:
    - Access Control ▸ Admin ▸ Role mappings has a new "Show on forms" column. Primary role and Additional role 1 say "Always". Additional role 2 and Additional role 3 each have a checkbox.
    - With neither ticked, raise a Joiner or a Mover: there is Primary role and one Additional roles box.
    - Tick Additional role 2 and save: the forms have two additional boxes. Tick Additional role 3 as well: three. Tick only the third: two boxes, the first and the third.
    - An unticked line is greyed. Its alt title and filter are kept but cannot be edited until it is ticked, and its "Roles offered" column says "Not shown".
    - A mover for somebody who holds several additional roles still shows all of them when only one box is on the form. Hiding a box never takes a role off a form.

    What happens on staging when this is deployed:
    - A company that has set nothing goes from three additional boxes to one.
    - Any Additional role 2 or 3 line that already has an alt title or a filter (for example, ones you set while testing COM-941 to 943) starts ticked, so it does not disappear. That was my call.

    Different from the task text: nothing.

    Looked at in a real browser (headless Chromium, stubbed data): the card with one line ticked and one not. The "Always" text, the checkboxes and the two input columns line up across all four lines.

    Technical: migration 0252 adds role_field_mappings.shown (default false) and ticks additional_2 and additional_3 rows that have a title or filter; tested against a table seeded at 0251, up and down. The forms' endpoint (GET /access-requests/role-fields) says which boxes are shown. With one Additional box on a form its accessible name is "Additional roles" with no number.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Part of the POC Tweaks sprint. Follows COM-940 to COM-943, which put three Additional roles boxes on every joiner and mover form. This makes the second and third optional. How the boxes that are left are arranged is the task after this one.

## What people see

- **Access Control ▸ Admin ▸ Role mappings gains a "Show on forms" column**, with a checkbox on the Additional role 2 line and on the Additional role 3 line. Both are unticked to begin with.
- **Primary role and Additional role 1 have no checkbox.** They are always on the forms, and their lines say "Always" in that column, so the four lines and their Alt title and Filter boxes still line up.
- **A box that is not ticked is not on the forms**: the new-joiner form, the mover form and the approver's edit of either. So a company has the primary and one additional box, the primary and two, or the primary and three.
- **The two are ticked independently.** Ticking only Additional role 3 gives two additional boxes, the first and the third.
- **Ticking is saved with the rest of the card**, by the same Save button, and Discard changes puts it back.
- **A line that is not ticked keeps its alt title and filter**, greyed out and not editable until it is ticked. Its "Roles offered" column says "Not shown".
- **Hiding a box never takes a role off a form.** Additional roles that are already there (what a mover holds today, what an approver is correcting) open in the boxes that are shown, by the same rule as now: the first shown box whose filter matches, then the first shown box with no filter, then the first shown box.
- **What this changes for a company that has set nothing:** its forms go from three Additional roles boxes to one, until somebody ticks the others.
- **A company that has already given Additional role 2 or 3 a title or a filter keeps that box**: it starts ticked. *(My call: "unchecked by default" is for a line nobody has set up. Otherwise a box somebody configured would vanish on the day this is deployed.)*

## Notes (technical)

- **Storage.** `role_field_mappings` gains `shown` (boolean, not null, server default false). Next migration is 0252. The rule "nothing set is no row" becomes "no title, no filter and not ticked is no row".
- **The migration ticks what is already in use:** `shown = true` where `field` is `additional_2` or `additional_3` and the row has a title or a filter. CI only ever migrates an empty database, so this branch is untested there; run it locally against a database with such rows before deploying.
- **API.** `RoleFieldMappingOut` and `RoleFieldMappingIn` gain `shown`. It is always true for `primary` and `additional_1`, whatever is sent. `GET /access-requests/role-fields` gains `shown` on each of the four boxes; the forms draw only the shown ones. Regenerate `schema.d.ts`.
- **The card** (`RoleMappingsSection.tsx`): a column between Field and Alt title. The `Checkbox` needs `w="fit-content"` for the screen-conventions test. The count for a hidden line is not asked for.
- **The forms** (`JoinerRoleFields.tsx`): draw the shown boxes only. `additionalBoxFor` is given the shown boxes' lists and its answer mapped back to the box. `useRoleFields` must default to "primary and Additional role 1 only" when it is told nothing, which is what every existing page-test stub tells it.
- **Accessible names.** With one Additional box shown and no title, its name is "Additional roles" with no number; existing tests find it as "Additional roles 1" and those that use the second or third box must now tick them in their stub.
- **Tests.** Backend: unticked by default, ticking saves, primary and Additional role 1 cannot be hidden, the forms' endpoint says which are shown, per company, and the migration's ticking of rows already in use (seeded with raw SQL at 0251, not through the models). Front end: the card's column and its greyed lines; forms with one, two and three additional boxes; a held role lands in a shown box when its own is hidden.

**Done when:** on staging a company with nothing ticked has one Additional roles box on its joiner and mover forms, ticking Additional role 2 adds a second and ticking Additional role 3 a third, and a mover who holds three additional roles still shows all three with only one box shown.