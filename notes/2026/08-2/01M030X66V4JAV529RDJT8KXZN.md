---
id: 01M030X66V4JAV529RDJT8KXZN
created: 2026-08-15T15:33:35.067649Z
updated: 2026-08-15T17:43:59.950715Z
type: task
title: Vendor contacts — child table, CRUD + Contacts card with compliance flag
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 214
sprint: sbph5q5
comments:
- id: 01M038BV5QB963ZZMY9FTWCAVB
  author: Steve Vine
  at: 2026-08-15T17:43:55.319236Z
  text: |-
    Done — PR #211 (feature/com-214-vendor-contacts → main). Full vertical slice as specified: model + migration 0055, /vendors/{id}/contacts CRUD, Contacts card.

    Followed the certifications pattern throughout, with three deliberate departures worth knowing:

    1. **The card is a table, not stacked rows.** Its sibling cards use Group rows, but five columns of short values read as a table — and the Compliance checkbox column only means anything when it lines up.
    2. **Compliance toggles in place** rather than through the edit modal. It's the one field somebody changes on its own; opening a modal to tick a box is a modal too many.
    3. **Delete is confirmed.** Certifications/engagements delete or retire straight from the row, but a contact is deleted outright (no `ended` equivalent — keeping a leaver's phone number "for history" would be the wrong instinct), so a mis-click is unrecoverable.

    Email is EmailStr, not a loose string: an address that's a typo is a questionnaire that silently never arrives, so it 422s at write time.

    The "not on the portal" line is held by two tests, not one — the portal route 404s, and the payload the portal *does* serve is asserted to carry no contacts key. The second is the regression that would actually happen: someone adding contacts to VendorOut for convenience.

    Ordering: compliance contacts first, then alphabetical, so the rows a reader wants are at the top of a long list.

    Backend 375 integration passing; frontend 269. OpenAPI regenerated; single Alembic head 0055.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Vendors need contact people. Mirrors the `vendor_certifications` child-table pattern end to end (model → `/vendors/{id}/contacts` CRUD → detail-page card). Vertical slice, one PR.

- [ ] **Model + migration**: `vendor_contacts` — `vendor_id` FK, `name` (required), `telephone`, `email`, `description` (optional), `compliance` bool default false. Append-only migration.
- [ ] **API**: `/api/v1/vendors/{id}/contacts` list/create/update/delete, gated like certifications (vendor-manager write, vendor read); email format validated. Any number of contacts; any number may carry the compliance flag (including none). OpenAPI regenerated.
- [ ] **Frontend**: **Contacts card** on the internal vendor detail page — table of contacts (Name, Telephone, Email, Description) with a **Compliance** checkbox column (heading "Compliance" — marks who will receive questionnaires); add/edit modal, delete with confirm. Editable by the same roles as the details card.
- [ ] **Not on the portal** (decided 2026-08-15): contacts are people-PII + internal questionnaire routing; exposing later is trivial, un-exposing isn't.
- [ ] Note: questionnaire *sending* doesn't exist yet (email capability is a backlog candidate) — the compliance flag is the addressing data that feature will consume.
- [ ] Tests: CRUD + validation + gating; card renders, compliance toggle persists.