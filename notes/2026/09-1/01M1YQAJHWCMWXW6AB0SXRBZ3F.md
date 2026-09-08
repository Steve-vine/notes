---
id: 01M1YQAJHWCMWXW6AB0SXRBZ3F
created: 2026-09-07T20:00:33.852156Z
updated: 2026-09-08T20:09:36.316822Z
type: task
title: 'Posture lists sort: Actions, Assessments, Gaps, Risks, Dashboard'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 611
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
comments:
- id: 01M1Z0QFWYPXTWJHW9J45QN9H0
  author: Steve Vine
  at: 2026-09-07T22:44:54.302405Z
  text: |-
    Done — PR #624 merged to main (rebased once after COM-618 landed in the same queue file).

    The sort convention applied to the posture lists:
    - actions/ActionsTable.tsx (shared by the internal Actions page and the portal's): type, what, company, owner, due, status. The column map names every column and the head renders whichever the caller shows, so a hidden Owner/Company column is simply never clicked. Unassigned owner is blank and sorts last; an overdue date is just an earlier date — overdue styling untouched.
    - Assessments queue: ref (numeric-aware), title, tier, status by lifecycle (Implemented → Partial → Not implemented → N/A → Not assessed), maturity as a number — within each domain block. The panel's previous/next step through the on-screen order.
    - Gaps: control ref, title, owner by directory name (unowned last), target date, status (Open → In progress → Closed).
    - Risks: title, category, inherent and residual score as numbers (the band is a function of the score, so worst-first is highest-first), status (Open → Treated → Accepted → Closed), owner (unassigned last).
    - Dashboard per-domain breakdown: coverage, compliance, maturity (none yet sorts last), open gaps. The rings get nothing.
    - components/ActivityHistory.tsx (Risk / Gap / Control detail): when, action, by (system last).

    Ranks live beside the colours: statusColors.ts gains SEVERITY_ORDER, ASSESSMENT_STATUS_ORDER, GAP_STATUS_ORDER, RISK_STATUS_ORDER, ACTION_STATUS_ORDER, ACTIVITY_ACTION_ORDER — one file for both vocabularies rather than a second copy. SortableTh gains `miw` for the pill columns.

    Tests: per page — click reorders, second click reverses, aria-sort on the active heading — plus statusColors.test.ts proving a severity column sorts Critical-first rather than alphabetically.
assignee: steve
label:
- feature
priority: medium
task_status: done
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
