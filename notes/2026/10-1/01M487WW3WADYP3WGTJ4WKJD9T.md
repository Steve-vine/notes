---
id: 01M487WW3WADYP3WGTJ4WKJD9T
created: 2026-10-06T09:14:44.220427Z
updated: 2026-10-06T13:42:02.379863Z
type: task
title: Each joiner on the new-joiner form gets Clear and Reset — empty the block, or put the role's defaults back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 846
sprint: sme8esk
blocked_by:
- 01M485X94AZDFKK464GADDPAD4
comments:
- id: 01M48Q68A0YCWX892KCE1EHMJ4
  author: Steve Vine
  at: 2026-10-06T13:42:00.256708Z
  text: |-
    Merged to main — PR #853 (2026-10-06).

    What people see now: two buttons in each joiner's block on the new-joiner form, beside the remove button — "Clear" and "Reset", as words, not icons. Each asks first and says what will happen; Cancel changes nothing.

    - Clear: "Clear this joiner? Everything entered for Ada Lovelace will be emptied — roles, display name, sign-in name and all other fields. Other joiners on this request aren't affected." ("…for this joiner…" if no name has been typed.) Confirmed, the block is emptied and stays there blank; the sign-in domain goes back to the default; other joiners aren't touched.
    - Reset: "Reset to Sales Executive's defaults? These fields go back to the role's default values:" then each field that will change as current → default, then "Roles, display name, sign-in name and fields without a default stay as they are." Confirmed, every field the primary role has a default for goes back to it — including ones the person changed — and nothing else moves. Those fields then follow a later change of primary role again.
    - Both are greyed out when they'd do nothing: Clear on an empty block; Reset with no primary role, a role with no defaults, or every defaulted field already on its default.
    - A default manager who has left isn't put back or listed.

    Technical: screen only, no server change. Clear makes the same blank block "Add another joiner" makes, so a field added later can't be missed. The list in the Reset prompt and the change it makes come from one calculation, shared with the approval prompt from COM-843.

    Tests: both prompts and their Cancel; Clear emptying roles, names, fields and the domain while leaving the other joiner alone; Reset restoring, keeping the rest, and following a later primary change; all the greyed-out cases; a default manager who has left.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Asked for by Steve, 2026-10-06. Builds on COM-843 (a role's default values fill the joiner form) and COM-845 (Primary role / Additional roles).

## What people see

Two buttons in each joiner's block on the new-joiner form, beside the block's remove button. **Each asks "are you sure?" first, saying briefly what is about to happen** (decided with Steve, 2026-10-06); nothing changes until the person confirms.

### Clear

Empties **everything** in that joiner's block: Primary role, Additional roles, Display name, User principal name, and every other field. The block itself stays, blank, ready to be filled in again — removing a joiner from the request is still the remove button.

- **The prompt:** "**Clear this joiner?** Everything entered for Ada Lovelace will be emptied — roles, display name, sign-in name and all other fields. Other joiners on this request aren't affected." Buttons: **Clear** / **Cancel**. (If no display name has been typed yet: "Everything entered for this joiner…")
- The sign-in domain goes back to the default one (COM-844).
- Other joiners in the same request are not touched.
- Greyed out when the block is already empty.

### Reset

Puts the primary role's defaults back, and leaves everything else alone.

- **The prompt:** "**Reset to Sales Executive's defaults?** These fields go back to the role's default values:" followed by the fields that will actually change, each as *current value → default value* (Department: Sale → Sales; Office: Chester → Wrexham). Then: "Roles, display name, sign-in name and fields without a default stay as they are." Buttons: **Reset** / **Cancel**.
- **Kept as they are:** Primary role, Additional roles, Display name, User principal name.
- **Set back to the default:** every field the primary role has a default value for — including ones the person had changed. That's the point of the button.
- **Left as they are:** every field the primary role has **no** default for, whatever is in them.
- After a Reset those fields behave as freshly filled defaults again: change the primary role and they follow it (COM-843's rule), until someone edits them.
- Greyed out when there's no primary role yet, when that role has no defaults, or when every defaulted field already holds its default — so the button being live means "something here differs from the role's defaults", and the prompt always has at least one field to list.

## Decisions taken (say if any is wrong)

- **Both buttons confirm first** (above). The Reset prompt lists the exact fields and values, in the same *current → default* form as the approval prompt in COM-843, so the two read alike.
- **On the raise form only.** When an approver corrects a request, there is nothing to Clear (the joiner is already raised), and "put the defaults back" is already offered there by COM-843's prompt when the primary role changes.
- **A default Manager who has since left isn't put back** by Reset — the same rule as when defaults are first filled in; the field is left as it is and isn't listed in the prompt.

## Notes (technical)

- Form: the per-joiner block in `JoinerRows`, `app/frontend/src/access/RaiseRequestModal.tsx` (rebuilt by COM-840 / COM-845; the remove `ActionIcon` is already there).
- The prompts are confirmations opened from inside a modal — use the app's existing confirm pattern for a modal-over-modal (see how the role page's "This changes people's access" and the delete confirmations are done) rather than `window.confirm`. Focus returns to the button that opened it on Cancel.
- Share the *current → default* list component with COM-843's gate prompt (person and country shown by name, dates in the app's date format) — one renderer, two callers.
- Clear = replace that row with the same blank row "Add another joiner" creates — one constructor for both, so a field added later can't be missed by Clear. That also resets the per-field "touched" flags COM-843 keeps.
- Reset = for each attribute in the primary role's defaults (the per-role map COM-843 loads): set the value and clear its "touched" flag. Attributes not in that map are not visited. The prompt's list and the applied change come from one computed diff, so what is shown is exactly what happens. No server call.
- Disabled states are derived from row state in render — no effects (repo hooks lint).
- Screen conventions: compact secondary buttons with visible labels ("Clear", "Reset"), not icon-only — the two are easy to confuse as icons; `aria-label`s that include the joiner ("Clear joiner 2") since the buttons repeat per block.
- No API change.

## Done when

- Clear and Reset each open a confirmation describing what will happen; Cancel changes nothing.
- Confirmed, Clear empties one joiner's block and nothing else; Reset restores the primary role's defaults, keeps the roles, name and sign-in name, and leaves non-defaulted fields alone.
- The Reset prompt lists exactly the fields that then change.
- Both buttons are disabled when they would do nothing.
- Tests: Clear (prompt names the joiner, cancel is a no-op, all fields incl. roles and domain emptied, other joiners untouched, disabled when empty); Reset (prompt lists the changing fields, cancel is a no-op, edited default restored, non-default field kept, roles/name/UPN kept, follows a later primary change, the three disabled cases, a vanished default manager not restored or listed).