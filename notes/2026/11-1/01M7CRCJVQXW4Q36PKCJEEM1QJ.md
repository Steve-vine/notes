---
id: 01M7CRCJVQXW4Q36PKCJEEM1QJ
created: 2026-11-14T10:06:59.447778Z
updated: 2026-11-14T10:07:05.004665Z
type: task
title: '"Add a pass/fail rule" (and "Edit the reads") in a check''s ⋯ menu on a control''s Evidence tab takes you straight to the rule, open and ready, instead of seeming to do nothing'
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

Why (checked in code on main): the menu item only expands the check's Details (`CollectionCard.tsx` → `CheckRow`, `onClick={() => setOpen(true)}`). The rule panel (`RulePanel`) is the last thing inside Details, below the captures and any held capture.
- If Details is already open, nothing changes at all.
- If it's closed, it opens, but the rule part is usually below the fold. Even then it only shows "Evidence only: no pass/fail rule judges it yet" with two small buttons.

**Edit the reads (advanced)** has the same weakness: its editor opens at the bottom of Details, out of view.

## What people see

1. **Add a pass/fail rule** opens the check's Details if it's closed, scrolls the rule section into view, and briefly highlights it. The rule section is open, with both ways to make one in front of the person:
   - **Ask Polaris for a rule** (when Polaris is available), and
   - **Write a rule**, already open, with the cursor in its first box.
2. **The pass/fail rule** (when the check has one) does the same, showing the rule, its state and Edit / Remove.
3. **Edit the reads (advanced)** opens the reads editor, scrolls it into view and puts the cursor in it.
4. This works whether Details was open or closed, and when the menu item is chosen twice in a row.
5. The check's own page (COM-1817) uses the same behaviour for its Add a pass/fail rule.

## Done when

- On a control's Evidence tab, choosing Add a pass/fail rule from the ⋯ menu always leaves the rule section on screen, open, with Write a rule ready and Ask Polaris for a rule offered. This holds with Details open or closed, on a check with several captures.
- The same is true for The pass/fail rule and Edit the reads (advanced).
- There's a vitest for each menu item, covering both the Details-open and Details-closed cases, and the Browser smoke clicks Add a pass/fail rule and sees the rule form.

**Independent** (front end only).