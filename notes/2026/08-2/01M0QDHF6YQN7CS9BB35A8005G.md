---
id: 01M0QDHF6YQN7CS9BB35A8005G
created: 2026-08-23T13:39:11.1987Z
updated: 2026-08-23T14:03:39.612335Z
type: task
title: 'Vendor History tab: Revision history gains a By column; the separate activity History panel goes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 393
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Since COM-382 the admin vendor History tab shows **two** stacked panels and reads as a confusing double history:

- **Revision history** (`RevisionsCard`, `vendors/detail/cards.tsx:812`) — #, When, Action, What changed
- **History** (`ActivityHistory`, `components/ActivityHistory.tsx`, mounted at `pages/VendorDetailPage.tsx:113`) — When, Action, By. Admin-only (ADR 0023 audit read API), which is why the user portal (`PortalVendorDetailPage.tsx:140`) shows only the first panel.

## Change

1. **Add a By column to Revision history** — visible in both the admin page and the user portal. `VendorRevisionOut` already exposes `created_by: uuid | None` (`api/v1/schemas.py:2399`), but a UUID is not a name: the API needs to serve something renderable (actor email/name, the way the activity API serves `actor_email`), with the same `System` fallback for actor-less rows.
2. **Remove the `ActivityHistory` mount from the vendor History tab** (`VendorDetailPage.tsx:113`). The revision table then carries everything the panel showed. Scope: the vendor page mount only — `ActivityHistory` is shared and stays on the other audited entities (risk / content item / decision).

## Care

- Check what the vendor activity log records that revisions do **not** (e.g. reads/exports/token events, deletions). If real entries only exist there, note what visibility is being given up on this tab — the audit trail itself (ADR 0023) is untouched, only this surface.
- The portal's Revision history is rendered to company users, not admins — confirm exposing the actor's email/name there is acceptable, or serve a display name.