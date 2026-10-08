---
id: 01M4EDXSQ6XZJY1068BB1EFD5K
created: 2026-10-08T18:55:32.582611Z
updated: 2026-10-08T18:56:03.883113Z
type: task
title: HITRUST readiness is shown domain by domain — nineteen rows, each with what is met, what is a gap and what is out of scope
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 879
sprint: sfkkkex
blocked_by:
- 01M4EDWB7JZG4NSWXHHX7X6V34
- 01M4EDX9CF152R4DRRD0G2QQGE
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Part of sprint 66, HITRUST Framework (ADR in COM-875; the library is COM-876, the level choice is COM-878). HITRUST certifies domain by domain, so one overall percentage hides the thing people need to see: which domains are in good shape and which are not.

## What people see

- **The HITRUST page has a readiness-by-domain table:** the nineteen domains in HITRUST's order.
- **Each row shows** the controls in scope, how many are met, how many are gaps, how many are out of scope, and the percentage met.
- **The columns sort.**
- **Choosing a domain narrows the control list to it.** The choice is kept in the address, so it survives a refresh and can be shared.
- **The control list can be grouped by domain or by HITRUST's categories.**
- **The table respects the company's choices:** the level it is working towards, and anything ruled out of scope. A domain with nothing in scope at the chosen level says so and shows no percentage.
- **There is no pass mark and no HITRUST score.** A row says how much of the domain is met, not whether it would certify.
- **ISO 27001 and ISO 42001 keep their two cards.**

## Notes (technical)

- **The tallies exist.** Coverage already reports per `part` (COM-420), and `FrameworkDetailPage.tsx` renders a card per part when there is more than one. Nineteen cards is the wrong shape: above a handful of parts the page renders a table, and the two-part frameworks keep their cards.
- **Above-level count.** The per-part tally carries `above_level` from COM-878, so a domain's row never counts a control the chosen level leaves out.
- **Table.** Kit `ListTable` with `SortableTh` on every column (the screen-conventions test requires it).
- **Filter and grouping.** URL-backed through the `useQueryState` hooks (COM-792); mind the flushSync note in [[url-backed-filters-flushsync]].
- **Order and labels** come from `PART_ORDER` / `PART_LABELS`, extended in COM-876.
- **Tests.** A page test with a many-part framework (table, sort, the filter narrowing the list, the empty-domain row) and one with a two-part framework still showing cards. Wait for the company-scoped fetch before clicking a heading ([[portal-tests-company-refetch-gap]]).
- The Dashboard is unchanged: it keeps one HITRUST figure.

**Done when:** on staging the HITRUST page shows nineteen domain rows whose counts add up to the headline, choosing a domain narrows the list and survives a refresh, and ISO 27001 still shows its two cards.