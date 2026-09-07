---
id: 01M1YQAJHWCMWXW6AB0SXRBZ3F
created: 2026-09-07T20:00:33.852156Z
updated: 2026-09-07T22:12:27.748232Z
type: task
title: 'Posture lists sort: Actions, Assessments, Gaps, Risks, Dashboard'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 611
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Apply the sort convention from *Every list sorts* to the lists that show where the company stands and what is outstanding. This is the half of the sweep where ranked sorting matters most — "worst first" is the whole reason a reader clicks a heading here.

## Pages

- `actions/ActionsTable.tsx` — **shared**: the same component renders the internal Actions page (`pages/ActionsPage.tsx`) and the portal's Actions page (`pages/PortalActionsPage.tsx`), so one change serves both. The Owner and Company columns are conditional (`showOwner`, `showCompany`) — the sort must not assume a fixed column set.
- `pages/AssessmentsQueuePage.tsx` — the assessment queue
- `pages/GapsPage.tsx` — the gap register
- `pages/RisksPage.tsx` — the risk register
- `pages/DashboardPage.tsx` — the per-domain breakdown table (Domain, Coverage, Compliance, Maturity, Open gaps). The rings above it are a summary and get nothing; the table is a real list and sorting by Open gaps or Compliance is the useful move.
- `components/ActivityHistory.tsx` — the per-entity history card on the Risk, Gap and Control detail pages

## Notes

- Severity, status, maturity and risk tier sort by **rank**: Critical → Low, not Critical → High → Low → Medium. Reuse the orderings already encoded in `components/statusColors.ts` rather than writing a second copy of them.
- Due dates sort as dates, and **overdue rows are not special-cased** — an overdue date is simply an earlier date. The existing overdue styling stays as it is.
- Rows with no owner or no due date sort last in both directions.

Tests: per page, a click reorders / a second click reverses; plus one test proving a severity column sorts Critical-first rather than alphabetically.
