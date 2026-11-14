---
id: 01M7CRCJVQXW4Q36PKCJEEM1QJ
created: 2026-11-14T10:06:59.447778Z
updated: 2026-11-14T11:57:39.038535Z
type: task
title: Remove "Add a pass/fail rule" from a check's ⋯ menu on a control's Evidence tab (it only expanded Details), and make "Edit the reads" land on its editor
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1818
sprint: spsp226
comments:
- id: 01M7CYQ3Q1S30XDHRGS4Y441PA
  author: Steve Vine
  at: 2026-11-14T11:57:35.841309Z
  text: |-
    Built — PR #1808 (5a11ec9a), auto-merge on. Frontend only.

    What you now see: a collected check's ⋯ menu on a control's Evidence tab has Ask Polaris to check this, Ask Polaris to re-create it, Change the fields it keeps, and Edit the reads (advanced) — the rule item is gone. The rule section in Details is unchanged (Ask Polaris for a rule / Write a rule, or Edit the rule / Remove the rule). Edit the reads opens Details if it's closed, scrolls the editor into view and puts the cursor in the reads box; choosing it again while open brings it back on screen.

    Choice: it waits 250 ms for Details to finish opening, then scrolls and focuses (a small shared helper, so other views can land the same way).

    Tests: collection/control/checks vitest pass (82); eslint/tsc/prettier clean; full suite green apart from load timeouts that pass on rerun.
assignee: steve
label:
- bug
priority: medium
task_status: review
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