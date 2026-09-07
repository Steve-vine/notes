---
id: 01M1YW6AD2WJ2PC86P8H7WZ8EP
created: 2026-09-07T21:25:37.31478Z
updated: 2026-09-07T21:30:53.123028Z
type: task
title: 'The assessment panel: a frozen nav row and a description that reads in full'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 618
sprint: sa2t9sq
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Two changes to the control panel on the right of the Assessments screen, both about one scrollport doing the work instead of three.

## 1. The nav row stays put, and says which control

The panel carries a thin row at the top: **"3 of 47"** on the left, back / forward / close on the right. It scrolls away with everything else. An assessor working down a long control loses the way to the next one exactly when they have finished with this one, and has to scroll back up to move on.

Freeze that row. It stays visible at the top of the panel however far down the control you have read; everything below scrolls under it.

**The control's reference joins it**, after the counter:

> `1 of 383 - INS.1`

The ref **moves** rather than being duplicated — it comes out of the block below, which is then the title on its own. Frozen, it answers "which control am I judging" at any scroll depth, which a bare pair of chevrons does not. The title stays in the body: it is a sentence, it wraps, and a head that changes height as you step through a run is worse than one that does not.

## 2. The description reads inline

The "what good looks like" text sits in its own capped scroll area (`ScrollArea.Autosize mah={220}`). A long description is therefore a small window onto a wall of text, inside a panel that already scrolls — and it is the part of the screen an assessor is meant to read before judging anything.

Remove the scroll area. The description renders inline as part of the panel's own flow, however tall it is, and the panel's scroll carries it.

This also settles a disagreement. The Playbook control page (`pages/ControlDetailPage.tsx`) already renders the same description inline with no cap — the panel's own docstring says the two entry points share their rendering precisely so they cannot drift, and this is one of the places they had. After this change they agree.

It is the only capped `ScrollArea` in the app; the two others are navigation sidebars.

## Where

`pages/AssessmentsQueuePage.tsx` → `ControlAssessmentPanel`. The panel is the `Paper` with `overflowY: 'auto'` — the queue and the control already scroll independently under one frozen page head (COM-539). The nav row is the same idea one level in.

## How

Do not reach for `position: sticky` inside the existing `Stack`. The Stack's `gap` leaves a transparent strip above the row, and the Paper's `p="md"` leaves another at the top of the scrollport — content shows through both as it passes. Split the Paper instead, the way `ScreenFrame` already splits a screen:

- The `Paper` becomes a flex column with no padding of its own, keeping `minWidth: 380` and its flex ratio.
- A **head** holds the nav row — counter, ref, and the three buttons: the panel's own padding, a bottom border, and a solid background so scrolling content passes behind it rather than through it.
- A **body** takes the remaining height with `overflowY: 'auto'` and the padding the Paper used to carry — the title, "Open in Playbook", the description, `AssessmentPanel`, and the three evidence cards.

Drop the `ScrollArea.Autosize` wrapper and the now-unused `ScrollArea` import, leaving the `TypographyStylesProvider` + `ReactMarkdown` pair exactly as the Playbook page has it.

## Watch for

- **The head must not wrap.** At the panel's 380px minimum it holds a counter, a ref and three buttons. The counter and ref are one non-wrapping text run and the ref truncates before the buttons give up any width — the buttons are the way out of the panel and the way through the run.
- The close button must stay reachable at every panel width — it is the only way out of the panel besides Escape.
- Moving to another control resets the body's scroll to the top; the panel already remounts on the control it is keyed to, so confirm this rather than assume it.
- With the inner scroll gone, a very long description pushes the assessment form further down the panel. That is the intended trade — the form was never the first thing to read — but it is the change most likely to draw comment on the first smoke test.

Tests: `AssessmentsQueuePage.test.tsx` — the nav controls are still found and still step through the run; one asserting the head shows the position and the ref together and is outside the scrolling body; one asserting the ref appears once on the screen, not twice; one asserting a long description renders in full rather than inside a capped region.
