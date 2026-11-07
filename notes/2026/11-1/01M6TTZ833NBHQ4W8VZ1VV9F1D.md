---
id: 01M6TTZ833NBHQ4W8VZ1VV9F1D
created: 2026-11-07T11:05:48.387182Z
updated: 2026-11-07T11:56:13.811611Z
type: task
title: 'Assessment: the left menu stays full size when a control is opened'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1632
sprint: sp69tt3
comments:
- id: 01M6TXVHSJF742K87JC623JHSM
  author: Steve Vine
  at: 2026-11-07T11:56:12.978698Z
  text: |-
    Done: PR #1642, merged to main as df9f0c24.

    What changed: opening a control on Assessments no longer folds the left menu. Opening, stepping through and closing leave it as you had it; your own toggle still folds it. ADR 0085 has an amendment to §5.

    Layout note: with the menu full width, windows narrower than about 1350px leave the control under 780px wide, so the assessment box sits above the guidance instead of beside it (the existing narrow layout). At 1440 it stays beside.

    Tested: the page asks the shell for nothing while a control is opened, stepped and closed.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Today, opening a control on Posture ▸ Assessments folds the left menu down to icons, and it comes back when the control is closed. Steve (2026-11-07): the menu should stay full size.

**Wanted behaviour:**
- Opening a control, stepping through the run and closing it leave the menu exactly as the user had it.
- The user can still fold the menu themselves with the existing toggle, and it stays folded until they unfold it.

**Done when:** in E2E Test Company, opening a control on Assessments leaves the menu full size; stepping to the next control and closing it change nothing; folding the menu by hand still works and stays folded while stepping.

**Implementation:** remove the `requestCollapsed` effect in `AssessmentsQueuePage` (the `focusing` effect, ~line 302) and its comment, and the doc-comment line "the menu folds to icons to make room". If nothing else calls `useShell().requestCollapsed`, consider removing it from the shell too. Check the narrow-layout maths (`NARROW_RECORD` = 780px measured on the pane): with the menu full width the record pane is narrower, so the card may drop above the guidance on smaller screens. Check at 1440 and 1280 wide and say what was seen. This reverses ADR 0085 §5: append an amendment to that ADR (never rewrite it). Update any test that pins the collapse.

**Independent:** no migration, no API change.