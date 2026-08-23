---
id: 01M0Q9PHGFW4FDG7ZY553M2R7F
created: 2026-08-23T12:32:03.087572Z
updated: 2026-08-23T12:32:08.023678Z
type: task
title: Delete a role from the Role matrix — the existing guarded soft delete gets its UI
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 392
sprint: s5gwx0s
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The backend is already done: `DELETE /business-roles/{id}` (`api/v1/business_roles.py`) is a guarded soft delete gated `require_access_write` — admin and **access_manager** — refusing with a 409 when the role is referenced by an open access request or an open recert campaign ("disable it instead"). No frontend affordance calls it, so an Access Manager cannot delete a role from the UI at all. Frontend-only task.

- [ ] **Delete role** on `RoleDetailPage`, beside the existing Disable/Enable toggle (header area, `RoleDetailPage.tsx:75`) — destructive styling, visible only to access-write users like the other write affordances (`canWrite`).
- [ ] **Confirm modal** before the call: the role's name typed back or an explicit confirm, stating what deletion means — the role leaves the matrix and pick-lists; history and past snapshots keep resolving (soft delete, ADR 0027/0028).
- [ ] **The 409s render as guidance, not failure**: surface the backend's message ("referenced by an open access request — disable it instead" / "open recertification campaign — disable it instead") in the modal with a one-click path to Disable, since that's the remedy the guard names.
- [ ] On success: navigate back to the Role matrix list; the deleted role is gone from the default view (the list already filters `deleted_at`).
- [ ] Optionally the same action on the `RolesPage` row overflow, if the row grows a menu — the detail page is the required home.

Refs: ADR 0027/0028 (guarded soft delete), COM-259 (list filtering), `business_roles.py` delete_role (the contract this UI surfaces).