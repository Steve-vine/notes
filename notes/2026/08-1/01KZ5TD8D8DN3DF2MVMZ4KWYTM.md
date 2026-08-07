---
id: 01KZ5TD8D8DN3DF2MVMZ4KWYTM
created: 2026-08-04T07:22:03.048503Z
updated: 2026-08-07T10:56:04.555281Z
type: task
title: 'Estate filters: one date-range picker per field, instead of four date boxes'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 528
order: 2.0
sprint: skxht3g
comments:
- id: 01KZ6967BGFEBQE93PY057RYD5
  author: Steve Vine
  at: 2026-08-04T11:40:21.232845Z
  text: |-
    Built — PR #452, branch feature/ise-528-date-range-picker. STACKED on #451 (ISE-527): it edits the same JSX block, so stacking avoids a guaranteed conflict and its diff against main includes that commit. No backend change.

    TOOK THE DEPENDENCY, ON THE NUMBER
    The build after the change lands on exactly the figure measured when the task was written: 1,470.04 kB JS / 239.03 kB CSS, ~17 kB gzipped over the previous bundle. The old comment's reasoning is replaced with the new reasoning AND the number, so whoever weighs this next has what I had rather than having to re-measure.

    NOTHING BELOW THE CONTROL CHANGED
    The filters still store plain YYYY-MM-DD strings exactly as the native inputs produced them. Persisted shape, query builder and API contract all untouched — `asRange` is a shape adapter, not a conversion. That is what kept this a presentation change.

    VERIFIED IN A REAL BROWSER, BECAUSE NOTHING ELSE COULD
    jsdom lays out no popover, so the entire feature was invisible to the suite. Via the dockerised Playwright rig:
    - The calendar renders correctly in BOTH themes — the specific risk you flagged.
    - Picking a range stores 2026-08-10 → 2026-08-17.
    - The filter badge counts it as ONE narrowing.
    - The control's clear returns both ends to empty and the badge to nothing — your "obvious way back to no filter".

    One honest note: my first probe reported both params missing from the request, which looked like a real bug. It was my harness stubbing window.fetch, so Playwright observed no requests at all — an artefact of the probe. Reading the stored state directly showed the correct values. Worth recording because a probe that lies looks exactly like a feature that is broken.

    TESTS
    The two tests that drove the old inputs now seed the persisted filters instead — the approach the type and integration filters already take. What they assert is unchanged: a whole day inclusive of the end, and one range counting as one filter. One new test asserts the four old accessible names are GONE rather than merely hidden behind the new control, which was your explicit "do not paper over it" trap.

    VERIFICATION
    Frontend 580 passed; eslint, prettier, npm run build clean.

    FOR YOU: the row now reads Tag / Type / Integration / Operated by / First Seen / Last Seen, with the two ranges taking about the space one old pair did. Worth your eye on whether 230px per range field is right — I sized it to fit the "2026-08-10 – 2026-08-17" text without truncating.
assignee: steve
priority: low
task_status: done
---
Raised alongside ISE-527. "First Seen" and "Last Seen" are each two `type="date"` boxes — four controls and roughly 620px for two filters, over half the filter row (`EstatePage.tsx:348-393`).

Worth doing on its own merits: four controls become two, and each reads as one idea rather than two halves an operator has to pair up mentally.

**It is not needed to make room.** `FilterPanel` already wraps (`FilterPanel.tsx:93`, `wrap="wrap"` — "a second line of filters grows the panel rather than shoving the table sideways"). ISE-527 can land without this. Do this because the row is bulky, not because it is full.

## It reverses a deliberate decision, so decide it on the number

`EstatePage.tsx:345-347` says it outright:

> *Native date inputs rather than a picker component: two of them are not worth `@mantine/dates` plus dayjs on a bundle already over the size budget, and the browser supplies a real calendar either way.*

That was a considered call, not an oversight. Overturning it needs the cost, so it was **measured** (2026-08-04, `DatePickerInput type="range"` built into the real bundle):

| | before | after | delta |
|---|---|---|---|
| main JS | 1,419.07 kB | 1,470.00 kB | **+50.9 kB** (+14.9 kB gzip) |
| CSS | 219.17 kB | 239.03 kB | **+19.9 kB** (+2.3 kB gzip) |

**~71 kB raw, ~17 kB gzip — about 4% of the 414 kB gzipped main bundle.** The build already warns past 500 kB, and `elk.bundled` is a second 1.4 MB chunk, so this is not what is wrong with the bundle. The original "not worth it for two of them" reasoning is also weaker now: it buys two range fields, not two date boxes, and any future date filter comes free.

Recommendation: take it. But record the reversal in the code comment where the old reasoning sits, with the measured number — the next person deserves the same evidence.

## The middle option, if the dependency is refused

Two native `type="date"` inputs inside one bordered wrapper with an arrow between them, presented as a single control. No dependency, one visual field, keeps the browser's own calendar and locale handling. Saves the duplicated labels and about half the width — not as clean, and no shared-calendar range selection.

## Traps

- **The API params do not change.** `first_seen_from/to` and `last_seen_from/to` are half-open ranges and stay exactly as they are (`entities.py`); this is presentation only.
- **Three test files reach for the current aria-labels** — `EstatePage.test.tsx` uses `First seen from`, `First seen to`, `Last seen to`. Renaming or collapsing them breaks those tests, which is correct and wanted; just do not paper over it by leaving hidden inputs with the old names.
- **A range picker needs an obvious way back to "no filter".** The native inputs clear themselves; a picker needs `clearable` and it must feed the same `activeCount` and "Clear filters" the panel already has.
- **Check both themes.** ISE has a light/dark toggle and a popover calendar is exactly the kind of surface that looks fine in one and wrong in the other.
- `@mantine/dates` needs its own `styles.css` import in `main.tsx`, and pins a `dayjs` peer.

## Definition of done

The Estate filter panel offers one date-range control for First Seen and one for Last Seen, each selecting both ends in a single calendar and clearing in one action, with the same results the four boxes gave. The bundle delta is recorded where the previous decision was written down.