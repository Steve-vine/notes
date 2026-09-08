---
id: 01M1YQA7AJTVZVAX9KPZ9ZA7PW
created: 2026-09-07T20:00:22.35422Z
updated: 2026-09-08T20:09:30.831881Z
type: task
title: 'Playbook lists sort: Frameworks, Domains, Controls, Content, Decisions'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 610
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
comments:
- id: 01M1YZYVMCE0FX6SG7J85NCCSB
  author: Steve Vine
  at: 2026-09-07T22:31:27.116132Z
  text: |-
    Done — PR #623 merged to main.

    The sort convention applied to the Playbook with useClientSort + SortableTh:
    - Frameworks register: name, version (numeric-aware: 8.1 after 8), requirement count, description, status by rank. Actions column excluded.
    - Domains register: name, code, CSF function (FUNCTION_ORDER), control count, status. Function order then curated order stays the default; a click is an overlay.
    - Domain detail controls: ref, title, status.
    - Controls index: the COM-608 worked example, nothing regressed.
    - Decisions: ADR number as a number, title, status by lifecycle (proposed → accepted → superseded → declined), decided date as a date.
    - Content list: title, type, kind (ADR 0035 order), status (draft → published), review date with blanks last. Checkbox column excluded.
    - Content types and templates tables; the three content-item histories (SharePoint versions, review record, published versions — newest-first default, the current version's blank "superseded" last either way).
    - Framework coverage table: ref, cover, posture (by rank; a heading row uses its rolled-up value), contributing-control count. It is a tree, so a sort reorders siblings under each heading and re-flattens depth-first — the grouping never dissolves. Scope column excluded.

    Not touched, and why: the framework detail's Crosswalk and Requirements tabs are card stacks under GroupHeading bands, not tables — no column headings to click, so the convention (a table listing many rows) does not reach them.

    Non-sorting columns carry a `{/* no-sort: … */}` comment beside the Table.Th, the escape COM-616's test will recognise. Two existing tests looked modal inputs up by label with exact:false and now also matched the "Sort by Title" heading button; they use getByRole('textbox') instead.

    Tests: one per page — click reorders, second click reverses, aria-sort on the active heading.
assignee: steve
label:
- feature
priority: medium
task_status: done
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
