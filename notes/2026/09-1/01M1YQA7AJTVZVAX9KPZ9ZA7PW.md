---
id: 01M1YQA7AJTVZVAX9KPZ9ZA7PW
created: 2026-09-07T20:00:22.35422Z
updated: 2026-09-07T22:12:27.705258Z
type: task
title: 'Playbook lists sort: Frameworks, Domains, Controls, Content, Decisions'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 610
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Apply the sort convention from *Every list sorts* to the Playbook registers and the lists on their detail pages.

## Pages

- `pages/FrameworksPage.tsx` — the framework register
- `pages/FrameworkDetailPage.tsx` — the requirements list. **Grouped** (`components/grouping.ts` / `GroupHeading`): sorting reorders rows *within* each group and never dissolves the grouping.
- `pages/DomainsPage.tsx` — the domain register. Its natural order is the curated `sort_order`, which stays the default; sorting is an overlay on top of it, not a replacement for it.
- `pages/DomainDetailPage.tsx` — the controls in the domain
- `pages/ControlsPage.tsx` — the control index (the worked example already landed in the parent task; check nothing regressed)
- `pages/ContentPage.tsx` and `pages/ContentDetailPage.tsx`, plus the shared tables in `content/components.tsx`
- `pages/DecisionsPage.tsx` — the decision register

## Notes

- Ref columns (control refs, requirement refs) are not plain text — `AC.10` must fall between `AC.9` and `AC.11`, not before both. Use a natural/numeric-aware comparison for them.
- Status and tier pills sort by rank, not alphabetically (Draft → Active → Retired; Essential → Expected → Specialised once COM's tier work lands).
- Coverage and count columns are numbers.

Tests: for each page, one test asserting a click reorders and a second click reverses, plus `aria-sort` on the active heading.
