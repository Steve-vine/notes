---
id: 01M1YWR6AZ51MSZ230892GRCXJ
created: 2026-09-07T21:35:22.97583Z
updated: 2026-09-07T21:35:25.681841Z
type: task
title: The row you are assessing looks selected, in both themes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 619
sprint: sa2t9sq
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
In the assessment queue, the row whose control is open in the panel beside it is marked — and you cannot see it. In light mode the mark is the same grey as every alternate row, so the selected row looks like a stripe. In dark mode it is barely there at all. The queue stays on screen precisely so an assessor knows where they are in a run of 383 controls, and right now it does not answer that.

## What it becomes

The selected row is tinted with the app's **brand accent** and carries a solid **accent bar down its left edge**. Both themes, both signals — the bar is the one that survives a dim screen, a colour-blind reader, and a row that happens to fall on a stripe.

**Not yellow**, though it was the first instinct and it is the loudest option. Yellow already means something in Compass: it is the pill colour for **Partial** control status and for **Medium** severity, both of which appear in this very table. A yellow row behind a yellow "Partial" pill asks the reader to work out which yellow is a status and which is a cursor. The accent is neutral — it already means "this is the thing" everywhere else in the app — so it says *selected* and nothing else.

## Where

`pages/AssessmentsQueuePage.tsx`, the queue `Table.Tr`. Today: `bg={open?.id === control.id ? 'var(--mantine-color-default-hover)' : undefined}`. That token is the hover colour, which is also near enough the stripe colour — one grey doing three jobs is the whole defect.

## How

- Tint from the brand scale, not `default-hover`. Light and dark need different shades of it for the same apparent strength — this is the `autoContrast` trap in reverse, so set the light and dark values explicitly rather than trusting one token to work in both.
- The bar is a left border on the row's first cell (or an inset box-shadow on the row), sized so it does not shift the column alignment of unselected rows by a single pixel.
- **Hover must still read on the selected row.** Right now selection borrows the hover colour, so hovering the selected row does nothing visible. After this they are different colours and both work.
- The domain heading rows (`DomainHeadingRow`) are never selectable and must not pick up either treatment.
- Contrast: the row's text, the status pill and the maturity badge all sit on the new tint. Check them in both themes rather than eyeballing light mode alone.

## Watch for

This is the only multi-row list in the app with a persistent selected row, so there is no existing token to reuse and none to add — resist making this a shared "selected row" component off the back of one call site. If a second screen grows the same need, that is when it becomes shared.

Tests: `AssessmentsQueuePage.test.tsx` — the selected row is distinguishable from an unselected one by a resolved colour, not merely by an attribute being present (the Mantine `autoContrast` lesson: assert the computed value).
