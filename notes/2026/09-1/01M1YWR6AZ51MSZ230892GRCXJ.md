---
id: 01M1YWR6AZ51MSZ230892GRCXJ
created: 2026-09-07T21:35:22.97583Z
updated: 2026-09-08T13:13:07.808547Z
type: task
title: The row you are assessing looks selected, in both themes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 619
sprint: sa2t9sq
comments:
- id: 01M20JD7SXM2F72R8F0RJEPVD4
  author: Steve Vine
  at: 2026-09-08T13:13:07.132854Z
  text: |-
    Done — PR #621 merged to main.

    In the Assessments queue the open control's row is now visibly selected in both themes: a faint brand wash plus a solid accent bar down its left edge. It used to borrow default-hover — the hover colour, and near enough the stripe that the selection read as a stripe in light mode and as nothing in dark.

    Decisions:
    - Values set explicitly per scheme on the row as custom properties (--row-selected-bg, --row-selected-bar, --tr-hover-bg): light = brand 0 wash / accent brand 7; dark = brand 9 flattened into the body colour at 45% / accent brand 4.
    - index.css paints the wash through a [data-selected-row] attribute selector — it ties Mantine's striping and wins on cascade, while Mantine's class + pseudo-class hover rule still outranks it, so hover still reads, through the deeper --tr-hover-bg the row sets. The bar is an inset shadow on the first cell, so no column moves by a pixel.
    - Not yellow: yellow is already Partial and Medium in this very table.
    - Domain heading rows and unselected rows pick up nothing. No shared "selected row" component — one call site.
    - theme.ts exports DARK_BODY; renderWithProviders takes an optional colorScheme for dark-mode assertions.

    Tests: the selected row resolves to the brand hex (light and dark, different values), the bar is the scheme accent, hover is a different colour from the resting tint, body-text contrast ≥ 4.5:1 computed on both washes; unselected rows and headings carry none of it; the mark follows the panel through the run.

    Worth a look on the smoke test: the wash is deliberately faint against COM-620's solid domain band — a filled band is structure, a wash is a cursor.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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
