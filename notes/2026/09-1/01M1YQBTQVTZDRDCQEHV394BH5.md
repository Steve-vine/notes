---
id: 01M1YQBTQVTZDRDCQEHV394BH5
created: 2026-09-07T20:01:15.003091Z
updated: 2026-09-07T23:01:41.136294Z
type: task
title: 'Admin lists sort: every tab, plus the Activity log'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 615
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
- 01M1YQ9X2BGPQ01BW0TXNP4KT6
comments:
- id: 01M1Z1P724N6V9JWCWFZXS7GB9
  author: Steve Vine
  at: 2026-09-07T23:01:41.060231Z
  text: |-
    Done — PR #626 merged to main.

    - Users (email, name, source, job title, roles by count, status active → disabled), Roles (name, permission / holder / mapping counts), Companies (name, slug, default first, status active → archived), Tokens (name, created, last used — never-used last).
    - The six rubric editors — Maturity, Risk (likelihood and impact scales, severity bands, appetite), Third-party risk tiers, Data (sensitivity, entities), Access, Criticality: a rubric opens in its own ladder order every time; the level / rank column and the name sort as an overlay, and sorting on the level column is the way back.
    - Called out, as the task asked: the data types table does NOT sort — its row order is the data, edited in place with the move buttons — and carries a no-sort-table comment. The one-row assessment-cadence setting is not a list and is marked likewise.
    - Review cadence (content type, months — none-yet last), Extra fields (label, type, help text), SSO mappings (group, roles conferred by count, affected users).
    - Admin → Files and Activity sort on the server, sending the order_by / direction COM-609 added, newest-first by default; a sort change restarts at page one. Activity's free-text Detail column is not orderable server-side and is marked.

    Tests: Users and Companies (reorder, reverse, aria-sort; default-first), Files and Activity (the request carries order_by/direction, newest-first by default, and returns to offset 0 on a sort change after paging), and MaturityRubricSection.test.tsx asserting a rubric opens in ladder order with no chevron lit, sorts by name as an overlay, and comes back on Level.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
