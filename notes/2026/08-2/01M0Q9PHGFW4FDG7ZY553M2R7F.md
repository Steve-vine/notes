---
id: 01M0Q9PHGFW4FDG7ZY553M2R7F
created: 2026-08-23T12:32:03.087572Z
updated: 2026-09-01T13:55:50.599205Z
type: task
title: Delete a role from the Role matrix — the existing guarded soft delete gets its UI
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 392
sprint: s5gwx0s
comments:
- id: 01M0QJ1Q0P6EV6KRER0FGQWDBV
  author: Steve Vine
  at: 2026-08-23T14:57:57.782191Z
  text: |-
    Done — PR #394 (feature/com-392-delete-role). Targets **main** directly: no migration, no dependency on the device or actor chains, so it can merge in any order relative to them.

    Frontend only, as the brief said. Delete role… sits beside the Disable/Enable toggle on RoleDetailPage behind the same `canWrite` gate.

    Two decisions worth recording:

    **Typed-name confirmation over a plain confirm.** The brief allowed either. The guard already means a deletable role is referenced by nothing open — so the only risk left is deleting the *wrong* role by misclick, and typing the name defeats exactly that at no other cost. The test includes a near-miss ("Finance Manger") that must not enable the button.

    **I did not use the shared `ConfirmDeleteButton`.** It closes the modal on confirm, and what happens when the server says no is the entire point of this task. The backend's 409 doesn't merely refuse, it *names the remedy* — so the refusal renders as a yellow guidance alert with **Disable it instead** as a working button, not a red error the reader has to translate. That's the brief's "one-click path to Disable", and it needs a modal that survives the failed call.

    The confirm copy states the soft-delete semantics before deletion is possible: the role leaves the matrix and pick-lists, but history, past requests and recert snapshots keep resolving and will still name it.

    Skipped the optional RolesPage row action — those rows have no overflow menu to grow, and the brief made the detail page the required home. Adding a menu just to hold one action would be a bigger change than the task.

    Three tests: the typed-name gate, the 409-as-guidance path with a working Disable, and the absence of *both* write affordances for a reader without access write (the delete and the toggle share one gate, so testing both together is what catches a gate applied to only one).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The backend is already done: `DELETE /business-roles/{id}` (`api/v1/business_roles.py`) is a guarded soft delete gated `require_access_write` — admin and **access_manager** — refusing with a 409 when the role is referenced by an open access request or an open recert campaign ("disable it instead"). No frontend affordance calls it, so an Access Manager cannot delete a role from the UI at all. Frontend-only task.

- [ ] **Delete role** on `RoleDetailPage`, beside the existing Disable/Enable toggle (header area, `RoleDetailPage.tsx:75`) — destructive styling, visible only to access-write users like the other write affordances (`canWrite`).
- [ ] **Confirm modal** before the call: the role's name typed back or an explicit confirm, stating what deletion means — the role leaves the matrix and pick-lists; history and past snapshots keep resolving (soft delete, ADR 0027/0028).
- [ ] **The 409s render as guidance, not failure**: surface the backend's message ("referenced by an open access request — disable it instead" / "open recertification campaign — disable it instead") in the modal with a one-click path to Disable, since that's the remedy the guard names.
- [ ] On success: navigate back to the Role matrix list; the deleted role is gone from the default view (the list already filters `deleted_at`).
- [ ] Optionally the same action on the `RolesPage` row overflow, if the row grows a menu — the detail page is the required home.

Refs: ADR 0027/0028 (guarded soft delete), COM-259 (list filtering), `business_roles.py` delete_role (the contract this UI surfaces).