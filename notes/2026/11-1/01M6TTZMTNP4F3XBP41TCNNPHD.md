---
id: 01M6TTZMTNP4F3XBP41TCNNPHD
created: 2026-11-07T11:06:01.429583Z
updated: 2026-11-07T11:14:36.734503Z
type: task
title: 'Assessment: the Up and Down arrow keys step to the previous and next control'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1633
sprint: sp69tt3
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
With a control open on Posture ▸ Assessments, the only ways through the run are the up/down buttons at the top right of the control's bar and Save & next. Steve (2026-11-07): once a control is selected, the keyboard Up and Down arrow keys should do the same as those buttons.

**Wanted behaviour:**
- Down opens the next control in the list, Up the previous one: the same filtered list and order as the buttons. At the first or last control the key does nothing, as the button is disabled.
- Unsaved changes on the card ask first, exactly as the buttons do.
- The keys are left alone while typing or choosing: in a text box (Notes, Applicability justification), a drop-down or list (owner picker, evidence picker), an open menu or a dialog. There, Up/Down keep their usual meaning.
- The tooltips on the two buttons name the keys ("Previous (↑)", "Next (↓)").
- With no control open, the keys do nothing new.

**Done when:** in E2E Test Company, with a control open, Down moves to the next control and Up back, matching the n / total counter; with Notes edited, Down asks before leaving; with the cursor in Notes, Up/Down move the cursor in the text and don't change control.

**Implementation:** add `ArrowDown`/`ArrowUp` to the existing `useHotkeys` call in `AssessmentsQueuePage` (beside Escape, ~line 296), calling `next`/`previous`, with the same dialog/menu/listbox guard as `onEscape`. Mantine's `useHotkeys` ignores INPUT/TEXTAREA/SELECT by default; check that the status and maturity button groups and any focused radio/segmented control aren't hijacked, and that the arrow doesn't also scroll the body (preventDefault when it steps). Note COM-828 removed J/K on purpose; arrow keys are a new, separate request. Add page tests for step, edge, guard and unsaved prompt.

**Independent:** no migration, no API change.