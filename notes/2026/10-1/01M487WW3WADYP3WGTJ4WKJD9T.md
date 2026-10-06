---
id: 01M487WW3WADYP3WGTJ4WKJD9T
created: 2026-10-06T09:14:44.220427Z
updated: 2026-10-06T09:14:47.586217Z
type: task
title: Each joiner on the new-joiner form gets Clear and Reset — empty the block, or put the role's defaults back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 846
sprint: sme8esk
blocked_by:
- 01M485X94AZDFKK464GADDPAD4
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Asked for by Steve, 2026-10-06. Builds on COM-843 (a role's default values fill the joiner form) and COM-845 (Primary role / Additional roles).

## What people see

Two buttons in each joiner's block on the new-joiner form, beside the block's remove button.

### Clear

Empties **everything** in that joiner's block: Primary role, Additional roles, Display name, User principal name, and every other field. The block itself stays, blank, ready to be filled in again — removing a joiner from the request is still the remove button.

- The sign-in domain goes back to the default one (COM-844).
- Other joiners in the same request are not touched.
- Greyed out when the block is already empty.

### Reset

Puts the primary role's defaults back, and leaves everything else alone.

- **Kept as they are:** Primary role, Additional roles, Display name, User principal name.
- **Set back to the default:** every field the primary role has a default value for — including ones the person had changed. That's the point of the button.
- **Left as they are:** every field the primary role has **no** default for, whatever is in them.
- After a Reset those fields behave as freshly filled defaults again: change the primary role and they follow it (COM-843's rule), until someone edits them.
- Greyed out when there's no primary role yet, when that role has no defaults, or when every defaulted field already holds its default — so the button being live means "something here differs from the role's defaults".

## Decisions taken (say if any is wrong)

- **Neither button asks "are you sure?".** They act on one joiner's block in a form that hasn't been submitted, and a confirmation on every click would get in the way. If an accidental Clear proves a nuisance in use, an Undo is the follow-on.
- **On the raise form only.** When an approver corrects a request, there is nothing to Clear (the joiner is already raised), and "put the defaults back" is already offered there by COM-843's prompt when the primary role changes.
- **A default Manager who has since left isn't put back** by Reset — the same rule as when defaults are first filled in; the field is left as it is.

## Notes (technical)

- Form: the per-joiner block in `JoinerRows`, `app/frontend/src/access/RaiseRequestModal.tsx` (rebuilt by COM-840 / COM-845; the remove `ActionIcon` is already there).
- Clear = replace that row with the same blank row "Add another joiner" creates — one constructor for both, so a field added later can't be missed by Clear. That also resets the per-field "touched" flags COM-843 keeps.
- Reset = for each attribute in the primary role's defaults (the per-role map COM-843 loads): set the value and clear its "touched" flag. Attributes not in that map are not visited. No server call.
- Disabled states are derived from row state in render — no effects (repo hooks lint).
- Screen conventions: compact secondary buttons with visible labels ("Clear", "Reset"), not icon-only — the two are easy to confuse as icons; `aria-label`s that include the joiner ("Clear joiner 2") since the buttons repeat per block.
- No API change.

## Done when

- Clear empties one joiner's block and nothing else; Reset restores the primary role's defaults, keeps the roles, name and sign-in name, and leaves non-defaulted fields alone.
- Both are disabled when they would do nothing.
- Tests: Clear (all fields incl. roles and domain, other joiners untouched, disabled when empty); Reset (edited default restored, non-default field kept, roles/name/UPN kept, follows a later primary change, the three disabled cases, a vanished default manager not restored).