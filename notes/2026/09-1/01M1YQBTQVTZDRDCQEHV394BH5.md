---
id: 01M1YQBTQVTZDRDCQEHV394BH5
created: 2026-09-07T20:01:15.003091Z
updated: 2026-09-07T20:01:15.003091Z
type: task
title: 'Admin lists sort: every tab, plus the Activity log'
label: feature
assignee: steve
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 615
---
Apply the sort convention from *Every list sorts* to Admin — the section with the most tables per screen and the least sorting.

## Pages

- `admin/UsersSection.tsx`, `admin/RolesSection.tsx`, `admin/CompaniesSection.tsx`, `admin/TokensSection.tsx`
- The rubric editors: `admin/MaturityRubricSection.tsx`, `admin/RiskRubricSection.tsx`, `admin/RiskTierRubricSection.tsx`, `admin/DataRubricSection.tsx`, `admin/AccessRubricSection.tsx`, `admin/CriticalityRubricSection.tsx`
- `admin/ReviewCadenceSection.tsx`, `admin/ExtraFieldsSection.tsx`, `admin/SsoMappingsPanel.tsx`
- `admin/FilesSection.tsx` — **server-side**, using the `order_by`/`direction` added by *Sorting the long lists*
- `pages/ActivityPage.tsx` — the activity log, also **server-side** for the same reason

## Notes

- **The rubrics are ordered ladders, and the ladder is the point.** A maturity rubric reads 0 → 5 and a severity rubric Critical → Low; that stays the default order every time the tab opens, and a reader who sorts by Label can always get back by sorting on the level column. Do not let a rubric open in any order other than its own.
- Where an admin table is directly editable (drag-to-reorder rows, inline edits), sorting must not fight the editing: if a table's row order is itself the data being edited, it does not sort. Call out any table that hits this rather than forcing it.
- Timestamps sort as dates; the Activity log keeps newest-first as its default.

Tests: Users, Companies, Files and Activity — reorder, reverse, `aria-sort`; plus one asserting a rubric opens in ladder order.
