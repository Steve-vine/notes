---
id: 01M4EDXSQ6XZJY1068BB1EFD5K
created: 2026-10-08T18:55:32.582611Z
updated: 2026-10-10T18:50:09.070884Z
type: task
title: HITRUST readiness is shown domain by domain — nineteen rows, each with what is met, what is a gap and what is out of scope
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 879
sprint: sfkkkex
blocked_by:
- 01M4EDWB7JZG4NSWXHHX7X6V34
- 01M4EDX9CF152R4DRRD0G2QQGE
comments:
- id: 01M4KJD8X2Z9JEFW7S1G096JEZ
  author: Steve Vine
  at: 2026-10-10T18:50:06.114825Z
  text: |-
    Merged to main as PR #903 (2026-10-10). Goes to staging with the rest of the sprint.

    What is there
    - The HITRUST page's Coverage tab has a "Readiness by domain" table: the nineteen domains in HITRUST's order.
    - Each row shows the controls in scope, how many are met, how many are gaps, how many are out of scope, and the percentage met. Every column sorts.
    - Choosing a domain narrows the control list to it. The choice is in the address, so it survives a refresh and can be shared. "Show every domain" clears it.
    - The control list can be grouped by category (HITRUST's own tree) or by domain. That choice is in the address too.
    - The table follows the level the company is working towards and anything ruled out of scope.
    - A domain with nothing in scope says so and shows a dash, not 0%. Wireless Security reads "No controls are filed under this domain", because everything HITRUST asks under it sits beneath a control filed elsewhere.
    - The table says what it is: a count of controls, not a HITRUST score, and no pass mark.
    - ISO 27001 and ISO 42001 keep their two cards. The Dashboard keeps one HITRUST figure.

    Decisions I took
    - A standard with more than four parts gets the table; four or fewer keep a card each.
    - Narrowed to a domain, the list keeps the category and objective headings its controls sit under, so a control is still read in its place.
    - A heading left with nothing beneath it in a section is dropped. Without this, choosing i1 would leave the main list as sixty-odd empty headings around eleven controls.

    To be aware of
    - Half the domain tags are unverified (76 of 156, COM-876), so the per-domain figures are only as good as that filing. Correcting a control's domain in the library moves it between rows straight away.

    Technical
    - Frontend only: the per-domain tallies, labels and order already came from the coverage response.
    - New component frameworks/DomainReadiness.tsx (kit ListTable, SortableTh on every column). domain, group and the table's sort go through the useQueryState hooks.
assignee: steve
label:
- feature
priority: medium
task_status: review
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