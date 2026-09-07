---
id: 01M1YW6AD2WJ2PC86P8H7WZ8EP
created: 2026-09-07T21:25:37.31478Z
updated: 2026-09-07T21:25:41.047814Z
type: task
title: The assessment panel's nav row stays put while the control scrolls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 618
sprint: sa2t9sq
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On the Assessments screen, the control panel on the right carries a thin row at the top: **"3 of 47"** on the left, and back / forward / close on the right. It scrolls away with everything else. An assessor working down a long control — description, the assessment form, frameworks, linked content, decisions — loses the way to the next control exactly when they have finished with this one, and has to scroll back up to move on.

Freeze that row. It stays visible at the top of the panel however far down the control you have read; everything below it scrolls under it.

## Where

`pages/AssessmentsQueuePage.tsx` → `ControlAssessmentPanel`. The panel is the `Paper` with `overflowY: 'auto'` — the queue and the control already scroll independently under one frozen page head (COM-539). This is the same idea one level in.

## How

Do not reach for `position: sticky` inside the existing `Stack`. The Stack's `gap` leaves a transparent strip above the row, and the Paper's `p="md"` leaves another at the top of the scrollport — content shows through both as it passes. Split the Paper instead, the way `ScreenFrame` already splits a screen:

- The `Paper` becomes a flex column with no padding of its own, keeping `minWidth: 380` and its flex ratio.
- A **head** holds the nav row: the panel's own padding, a bottom border, and a solid background so scrolling content passes behind it rather than through it.
- A **body** takes the remaining height with `overflowY: 'auto'` and the padding the Paper used to carry — the ref and title, "Open in Playbook", the description, `AssessmentPanel`, and the three evidence cards.

Only the counter row freezes. The reference and title scroll with the rest, as they do now.

## Watch for

- The close button must stay reachable at every panel width — it is the only way out of the panel besides Escape.
- Moving to another control resets the body's scroll to the top; the panel already remounts on the control it is keyed to, so confirm this rather than assume it.
- The description already has its own inner scroll (`ScrollArea.Autosize mah={220}`). Two nested scrollports plus a frozen head is the thing most likely to go wrong here — check the wheel still reaches the outer body when the pointer is over the description.

Tests: `AssessmentsQueuePage.test.tsx` — the nav controls are still found and still step through the run; add one asserting the head is outside the scrolling body.
