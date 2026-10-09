---
id: 01M4H8HZD5TYTFZ4PS2AXD44C5
created: 2026-10-09T21:19:25.605035Z
updated: 2026-10-09T21:20:02.154511Z
type: task
title: 'Move form: "Shared mailbox diff" sits directly under "Membership diff (manual groups)"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 895
sprint: sme8esk
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Raised by Steve on staging, 2026-10-09 (`b2e4240a`): "Move the Shared Mailbox Diff section up under the Membership diff (manual groups) section."

## What people see today

On a move, top to bottom:

1. Membership diff (managed groups)
2. Membership diff (manual groups)
3. Role groups
4. Manual groups
5. Dynamic groups
6. Shared mailbox diff
7. Shared mailboxes

So what the move *changes* is split by three lists of what it leaves alone.

## What people should see

1. Membership diff (managed groups)
2. Membership diff (manual groups)
3. **Shared mailbox diff**
4. Role groups
5. Manual groups
6. Dynamic groups
7. Shared mailboxes

Everything the move changes first, then everything the person keeps. Nothing else about either mailbox section changes — "Add a shared mailbox" stays with the diff, and the list of what they hold stays at the bottom.

## How (implementation)

- `app/frontend/src/access/RaiseRequestModal.tsx` (~l.980) renders `<MoverStayingGroups>` then `<MoverMailboxes>`, and each of those renders its own diff *and* its own "kept" lists — so the order can't be changed by swapping the two. Either split `MoverMailboxes` into two exported pieces (diff, and held list) that share state through the props the modal already owns (`mailboxAdds` / `mailboxDrops`), or give `MoverStayingGroups` a slot rendered between its diff and its Role groups section. Prefer the split: the mailbox popover's Remove (in the held list) and the diff's Restore already meet only through `drops`.
- The mailbox diff only renders once the preview has loaded (`preview &&`); the group sections don't wait for it. Keep the layout from jumping — the diff's place should hold "Working out what changes…" or nothing, consistently with the managed-groups diff above it.
- Tests: `MoverMailboxes.test.tsx` and `MoverRoles.test.tsx` find sections by `role="group"` name, so they shouldn't care about order; add one assertion on the order of the section headings.
- Frontend only. Touches the same files as the dynamic-group popup task and the shared-mailbox removal task — do the three as one stack, or one after another, not in parallel.

## Done when

- [ ] The sections appear in the order above.
- [ ] Add / Remove / Restore for mailboxes work as before.
- [ ] No jump in the layout while the preview loads.