---
id: 01M0QDHF6YQN7CS9BB35A8005G
created: 2026-08-23T13:39:11.1987Z
updated: 2026-08-25T18:43:34.992979Z
type: task
title: 'Vendor History tab: Revision history gains a By column; the separate activity History panel goes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 393
sprint: sbph5q5
comments:
- id: 01M0R5AQWAAJKFMEF59EDHWFRH
  author: Steve Vine
  at: 2026-08-23T20:34:56.522419Z
  text: |-
    Done — PR #398 (branch feature/com-393-revision-by-column).

    **1. The By column.** `VendorRevisionOut` gains `created_by_name`: the display name (`User.name`, falling back to email), resolved on read from `created_by` in one batched lookup for the whole list — no per-row query on a table that grows with the vendor's life. Reused `vendor_history`'s existing name resolution (extracted as `names_for`) so a person is named one way throughout the history.

    Two judgements the task asked for:
    - **Name, not email.** The portal renders this table to company users, so it carries the display name rather than the `actor_email` the admin-only activity API serves. That answers the "confirm exposing the actor's email is acceptable" care point — it isn't exposed.
    - **Resolved, not snapshotted.** "Who" doesn't change when a person is renamed, so the name is looked up at read time rather than frozen into the revision.

    Actor-less revisions come back `None` and render as "System" — the real case is the cadence-expiry beat (`tasks/reminders.py` writes `actor_id=None`), not a hypothetical.

    **2. The activity panel is gone from the vendor History tab.** Only that mount; `ActivityHistory` stays on risks and decisions, and the audit trail itself (ADR 0023) is untouched.

    **What that surface gives up** (the care point): the soft-delete entry — the one vendor mutation that writes activity but no revision (`delete_vendor` sets `deleted_at`; the `before_flush` listener records it as `deleted`). It was unreachable from this tab anyway, since a deleted vendor's detail page is a 404. Everything else that touches `vendors` goes through `write_vendor_revision`, so the revision table is the fuller record, not the thinner one. `/api/v1/activity` still holds the lot.

    Tests: integration test over the API for the resolved name, the rename case and the `None`/System path; frontend tests for the By column on both the admin page and the portal, and for the History tab making no `/activity` request at all.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
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