---
id: 01KZ5TD8D8DN3DF2MVMZ4KWYTM
created: 2026-08-04T07:22:03.048503Z
updated: 2026-08-04T11:31:04.045829Z
type: task
title: 'Estate filters: one date-range picker per field, instead of four date boxes'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 528
order: 2.0
sprint: skxht3g
assignee: steve
label:
- improvement
priority: low
task_status: active
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