---
id: 01KZVCNXG1G69FRWXQD32J3QG6
created: 2026-08-12T16:25:24.225749Z
updated: 2026-08-12T16:26:43.854798Z
type: task
title: 'Findings list: title collapses to nothing (only badges show) on narrow widths — table-fixed columns overflow'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 169
sprint: skesb93
assignee: steve
imported_from: linear
label:
- bug
priority: high
task_status: done
---
## Summary

In the findings list, a finding's **title can render as nothing — only its CVE pills (KEV/Conditional) show — and the title link isn't clickable**. The pills also overlap the Asset column. Reported for a conditional version-cve finding on asset `4ff193ef`; reproduced in the smoke company.

## Root cause

`finding-list.tsx` renders a `table-fixed` table whose six fixed-width columns total ~**56rem** (Severity w-28 + Status w-36 + Engine w-40 + Asset w-32 + First seen w-44 + SLA w-44). The **Title** column is auto-width = leftover. When the table area is narrower than ~56rem (common with the app sidebar / smaller laptops), the Title column collapses to ~0, so:

* the title `<Link>` (which used `truncate` only, no `min-w-0`/`flex-1`) truncates to zero width → invisible + not clickable;
* the `shrink-0` `CveBadges` overflow into the neighbouring Asset column.

Confirmed visually (screenshot): the row shows `Critical | New | — | [KEV][Conditional overlapping asset id] | …` with no title.

## Fix (shipped)

`finding-list.tsx`:

* Wrap the table in `overflow-x-auto` and give it `min-w-[64rem]` so the Title column always has real width and the table scrolls horizontally on narrow viewports instead of crushing the title.
* Title link: `min-w-0 flex-1 truncate` (canonical flex-truncate) so it reliably claims the available space, truncates with an ellipsis, and stays clickable; badges stay `shrink-0` beside it.

## Acceptance criteria

* The finding title renders (truncated as needed) and is a clickable link on all viewport widths; pills sit beside it without overlapping other columns.
* Verified on dev with a conditional + KEV finding.

## Notes

Pure CSS/layout — DOM was always correct (jsdom tests pass), so it's a visual regression only. Surfaced by the version-cve conditional findings (DEV-626) which add the amber Conditional pill.

---

Imported from Linear [DEV-694](https://linear.app/stevevine/issue/DEV-694/findings-list-title-collapses-to-nothing-only-badges-show-on-narrow)