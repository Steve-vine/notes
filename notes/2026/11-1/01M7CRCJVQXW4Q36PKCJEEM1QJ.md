---
id: 01M7CRCJVQXW4Q36PKCJEEM1QJ
created: 2026-11-14T10:06:59.447778Z
updated: 2026-11-14T10:09:00.632006Z
type: task
title: Remove "Add a pass/fail rule" from a check's ⋯ menu on a control's Evidence tab (it only expanded Details), and make "Edit the reads" land on its editor
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1818
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
## What happened

On 2026-11-14 Steve opened a control's **Evidence** tab and chose **Add a pass/fail rule** from a collected check's ⋯ menu. Nothing seemed to happen.

Why (checked in code on main): the menu item only expands the check's Details (`CollectionCard.tsx` → `CheckRow`, `onClick={() => setOpen(true)}`). The rule section (`RulePanel`) is the last thing inside Details, below the captures.
- If Details is already open, nothing changes at all.
- If it's closed, it opens, but the rule section is usually below the fold.

**Steve's decision: remove the item.** The rule section in Details already has the real controls (**Ask Polaris for a rule**, **Write a rule**, Edit / Remove), and the check's own page will have them too (COM-1817).

## What people see

1. The ⋯ menu no longer has **Add a pass/fail rule** or **The pass/fail rule**. It keeps Collect now, Ask Polaris to check this, Ask Polaris to re-create it, and Edit the reads (advanced).
2. A rule is added or changed in the check's Details, in the rule section, as today, and on the check's page once COM-1817 lands.
3. **Edit the reads (advanced)** had the same weakness: its editor opened at the bottom of Details, out of view. It now opens Details if needed, scrolls the editor into view and puts the cursor in it. This was my addition; drop it if Steve says so.

## Done when

- The ⋯ menu on a collected check on a control's Evidence tab has no rule item.
- The rule section in Details still offers Ask Polaris for a rule / Write a rule (no rule yet) or Edit / Remove (with a rule).
- Edit the reads (advanced) always leaves its editor on screen with the cursor in it, whether Details was open or closed.
- Vitest is updated for the menu, and there's one for Edit the reads landing on its editor.

**Independent** (front end only).