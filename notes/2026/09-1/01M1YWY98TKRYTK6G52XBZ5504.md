---
id: 01M1YWY98TKRYTK6G52XBZ5504
created: 2026-09-07T21:38:42.586273Z
updated: 2026-09-08T20:11:26.298395Z
type: task
title: 'Domain headings read as headings: a solid blue band'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 620
sprint: sa2t9sq
comments:
- id: 01M1YYVWGXMNV6K89WTN0SGAGQ
  author: Steve Vine
  at: 2026-09-07T22:12:21.149223Z
  text: |-
    Done — PR #620 merged to main.

    DomainHeadingRow (shared by the Controls list and the Assessments queue) is now a solid brand band with a white label, small, bold, uppercase — a section header rather than a grey wash that vanished into the striping.

    Decisions:
    - Fill set explicitly per scheme as a literal, not a token. Light: brand shade 7 (#1772a8) — white on it is 5.3:1. Dark: the dark-mode accent (shade 4, #4aace0) gives white only 2.5:1, so the band fills with shade 8 (#155d89, 7.1:1) instead. Checked by number, not assumed.
    - Label loses c="dimmed".
    - The inline background stays: it is what opts the heading out of striping and hover (components/grouping.ts) — a solid band that dimmed on hover would look like a button.
    - Call sites unchanged. GroupHeading on the Framework detail page left for its own pass, as the task says.
    - Weighted deliberately against COM-619's selected row (faint wash + bar): a filled band is structure, a wash is a cursor.

    Tests: library/DomainHeadingRow.test.tsx — resolved background is the brand hex in both schemes and white reads on it (WCAG ≥ 4.5:1 computed), the dark accent is proven not to; label white, never dimmed; inline background survives.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Both the Controls list and the Assessments queue read in domain order, with a heading row naming each block. The heading is supposed to be the thing that lets a run down 383 controls read as sections rather than one endless list — and it disappears into the table. It is a faint grey band carrying small, dimmed, uppercase grey text: quieter than the rows it is meant to introduce.

Two separate causes, and fixing only one leaves it just as flat:

- The band is `var(--mantine-color-default-hover)` — near enough the striping to vanish, and the same token the selected row uses (see *The row you are assessing looks selected*).
- The text is `c="dimmed"`. Dimmed grey on a faint band is the failure; dimmed grey on a **blue** band would be the same failure at a different hue.

## What it becomes

A **solid blue band** — the brand cerulean at full strength, not a tint — with its label in white, still small, bold and uppercase. It stops being a quiet stripe and becomes a section header, which is what it is.

## It must not compete with the selected row

Compass's brand *is* blue (a blue-leaning cerulean, `theme.ts`), and *The row you are assessing looks selected* tints the selected row with that same accent. On the Assessments queue the two sit inches apart, so they are deliberately given different weights:

| | Treatment | Reads as |
|---|---|---|
| Domain heading | **Solid** brand fill, white label | structure — a header |
| Selected row | **Faint** brand wash + left accent bar | a cursor — where you are |

A filled bar and a wash are not confusable even in the same hue. Do not let either drift toward the other's weight; that is the whole reason this is written down.

## Where

- `library/components.tsx` → `DomainHeadingRow` — the shared component, used by both pages
- `pages/ControlsPage.tsx` and `pages/AssessmentsQueuePage.tsx` — call sites only, no change expected

One component serves both pages, so this is a single change in one place.

## How

- Set the fill explicitly per theme rather than trusting one token: the light-mode accent (brand shade 7) and the dark-mode accent (shade 4) are different colours by design, and the label's contrast against each has to be checked, not assumed. Mantine's `autoContrast` is a silent no-op given a bare colour name — pass a shade and assert the resolved value.
- The label loses `c="dimmed"` entirely.
- The heading already opts out of striping and hover with an inline style (`components/grouping.ts` explains why the inline style is load-bearing); keep that opt-out — a solid band that dims on hover would look like a button.
- The heading spans the full table width (`colSpan`), which stays as it is.

## Not in scope

`GroupHeading` / `GROUP_HEADING_ROW_STYLE` — the requirement group bands on the Framework detail page — have the same weakness and a *third* grey token again (`--mantine-color-default`). Same idea, different screens, and worth its own pass rather than being smuggled in here.

Tests: the heading's resolved background is the brand colour, not a grey token, in both themes; the label is not dimmed; a heading row still does not stripe or hover.
