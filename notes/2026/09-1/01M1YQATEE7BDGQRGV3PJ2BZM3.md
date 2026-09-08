---
id: 01M1YQATEE7BDGQRGV3PJ2BZM3
created: 2026-09-07T20:00:41.93431Z
updated: 2026-09-08T20:09:44.990738Z
type: task
title: 'Vendor lists sort: the register and the vendor tabs'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 612
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
comments:
- id: 01M1Z1P6KZQEQJMA1ZE87J3CSG
  author: Steve Vine
  at: 2026-09-07T23:01:40.606883Z
  text: |-
    Done — PR #625 merged to main (stacked on COM-611 for the rank arrays, restacked once it landed).

    - Vendor register: name; state (requested → active → dormant → offboarded); compliance (non-compliant → under review → compliant → not assessed); risk tier and criticality by the ADR 0060 ladder, worst first, a vendor with no tier yet last; certified (expired → expiring → valid); flags by count then names; owner as the register names them, unassigned last.
    - Vendor detail (vendors/detail/cards.tsx): the reviews table (date, kind, outcome worst-first, compliance, reviewer, findings), the revision history (newest-first default; a revision's change lines stay under it) and contacts (compliance contacts first). Actions excluded. The engagement, assurance, flags, linked-risk and certification cards are fact panels and card stacks, not tables, so they get nothing.
    - Grouped requests (vendors/RequestGroupTable.tsx, shared with the portal's My Approvals): a click reorders whole groups by their request row; the area decisions stay indented under their request; the group's own sequence stays the default.
    - statusColors.ts gains the vendor ranks beside the colours; the tier reuses SEVERITY_ORDER.

    Tests: the register (tier worst-first with the untiered last, reverse, aria-sort), two detail tables (reviews by outcome rank and date; contacts by name and compliance-first), and the grouped table (groups reorder by vendor with each area under its request).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Apply the sort convention from *Every list sorts* to Vendor Management.

## Pages

- `pages/VendorsPage.tsx` — the vendor register
- `vendors/detail/cards.tsx` — the tables on a vendor's detail tabs (the largest single collection of tables in the app: engagements, assessments, assurance, contacts, requests, history). Every one that lists many rows of the same kind sorts; the fact panels do not.
- `vendors/RequestGroupTable.tsx` — the grouped request tables

## Notes

- Risk tier sorts by rank, worst first, using the ladder from ADR 0060 — not alphabetically.
- Review and expiry dates sort as dates; a vendor with no next review sorts last.
- Where a table already opens in a deliberate order (an assurance profile's themed column groups, a request group's own sequence), that stays the default and sorting is the overlay.

Tests: the register plus at least two of the detail tabs, asserting reorder, reverse and `aria-sort`.
