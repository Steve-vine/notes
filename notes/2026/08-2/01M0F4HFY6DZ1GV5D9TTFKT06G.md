---
id: 01M0F4HFY6DZ1GV5D9TTFKT06G
created: 2026-08-20T08:27:59.302957Z
updated: 2026-08-20T11:10:41.372124Z
type: task
title: A stray click outside a modal throws the form away — close only on the X or an action
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 308
sprint: sbph5q5
assignee: steve
label:
- bug
priority: high
task_status: active
---
Every modal in Compass closes when you click the page behind it — Mantine's `closeOnClickOutside` defaults to `true`. Half-filled forms are lost to a misplaced click, and the forms this hurts most are the long ones: requesting a vendor (name, contacts, the whole engagement section), amending an engagement, adding an assessment. Nothing warns, nothing is recoverable, and the click that does it is the one people make when they mean to scroll or to look at something behind the dialog.

**One line, in one place.** `src/theme.ts` already carries app-wide component conventions (`Table`, `Card`, `Paper` — ADR 0022), so this belongs there rather than on **63 `<Modal>` sites across 40 files**:

```ts
Modal: Modal.extend({
  defaultProps: { closeOnClickOutside: false, closeOnEscape: false },
}),
```

Checked before writing this, so the change is safe to make globally:

- [ ] **No modal would become inescapable.** There is no `withCloseButton={false}` anywhere in the codebase — every modal already has an X.
- [ ] **Nothing to conflict with.** No site currently sets `closeOnClickOutside` or `closeOnEscape`, so the default is not being deliberately overridden anywhere today.
- [ ] **No `Drawer` and no `@mantine/modals` manager** in the codebase, so `Modal` is the whole surface — there is no second component with the same behaviour to chase.
- [ ] **The overlay is still there to click**; it just stops being a destructive control. Worth checking the cursor over it does not still suggest it is clickable.

**One thing to decide rather than assume — the Escape key.** The brief says "only the X or an action button", which means Escape off, and that is what the snippet above does. But Escape-to-close is the WAI-ARIA dialog convention and it is a *deliberate* keystroke, not the accident this task exists to stop — keyboard and screen-reader users reach for it first, and it is the only close affordance that does not require finding the X. Recommend keeping `closeOnEscape: true` and turning off click-outside alone; if you want both off it is the same one-liner, so this is a choice not a cost.

- [ ] Tests: a click on the overlay leaves an open modal open; the X still closes it; a submit still closes it on success; and whichever way Escape is decided, it is asserted so the decision cannot drift back.
