---
id: 01M030X66V4JAV529RDJT8KXZN
created: 2026-08-15T15:33:35.067649Z
updated: 2026-08-15T15:33:38.210734Z
type: task
title: Vendor contacts — child table, CRUD + Contacts card with compliance flag
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 214
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Vendors need contact people. Mirrors the `vendor_certifications` child-table pattern end to end (model → `/vendors/{id}/contacts` CRUD → detail-page card). Vertical slice, one PR.

- [ ] **Model + migration**: `vendor_contacts` — `vendor_id` FK, `name` (required), `telephone`, `email`, `description` (optional), `compliance` bool default false. Append-only migration.
- [ ] **API**: `/api/v1/vendors/{id}/contacts` list/create/update/delete, gated like certifications (vendor-manager write, vendor read); email format validated. Any number of contacts; any number may carry the compliance flag (including none). OpenAPI regenerated.
- [ ] **Frontend**: **Contacts card** on the internal vendor detail page — table of contacts (Name, Telephone, Email, Description) with a **Compliance** checkbox column (heading "Compliance" — marks who will receive questionnaires); add/edit modal, delete with confirm. Editable by the same roles as the details card.
- [ ] **Not on the portal** (decided 2026-08-15): contacts are people-PII + internal questionnaire routing; exposing later is trivial, un-exposing isn't.
- [ ] Note: questionnaire *sending* doesn't exist yet (email capability is a backlog candidate) — the compliance flag is the addressing data that feature will consume.
- [ ] Tests: CRUD + validation + gating; card renders, compliance toggle persists.