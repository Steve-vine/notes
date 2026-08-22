---
id: 01M0MBNNT8WQTC58S1RENCSW6G
created: 2026-08-22T09:08:48.584157Z
updated: 2026-08-22T11:13:06.396632Z
type: task
title: Vendor ownership requires a qualifying role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 348
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
comments:
- id: 01M0MG1P19K7S32ESWBR8QDKE5
  author: Steve Vine
  at: 2026-08-22T10:25:16.329091Z
  text: |-
    Done — merged as #350 (dcb7605).

    Qualifying set is `{admin, vendor_admin, vendor_user}` as specified. **`viewer` is deliberately outside it**, which is worth stating because it reads the register: it acts on nothing, so a `viewer` owner is the stranded owner under a different name.

    Enforced in `core/vendor_ownership.py` as `require_owner_candidate`, which absorbed the old `_active_user_or_404` — the disabled-account check and the role check are one function because they are one rule with one reason ("an ownership nobody can exercise"), and they answer with the same 404.

    **One thing the ticket's "one place" needed splitting for:** `vendors.py`'s `_validate_owner` was doing double duty — vendor `owner_id` *and* review-action `owner_id`. Those are different concepts (a remediation assignee says nothing about who can reach the vendor record), so there are now two validators with the distinction written down, and only the vendor one asks about roles. `POST /vendors` with an `owner_id` gets it too, not just PATCH.

    **Pickers:** the portal's `/portal/directory` filters unconditionally — it has exactly one purpose. `/users/directory` could not, because it also feeds the risk, action and recertification pickers; it takes an opt-in `can_own_vendors` flag instead, which `useVendorDirectory` passes on the internal door. An existing portal-directory test needed updating: its "Grace Analyst" fixture is now correctly filtered out.

    The requester path is asserted rather than re-checked, as the ticket asked — `require_vendor_submit` and the qualifying set are literally the same three roles, so a second gate would be a second thing to keep in step.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Closes the stranded-owner gap: today owner/co-owner/transfer targets are validated as "active user" only, so someone with no portal access can end up accountable for a vendor — `is_owner()` true, every surface 403, review-due reminders (`tasks/reminders.py`) landing in their digest for a record no screen will show them.

`vendor_user` is granted to most staff but deliberately not all (kitchen assistants, cleaners…), so the rule is: **only role-holders can be made owners**.

- [ ] Qualifying set: `vendor_user`, `vendor_admin`, `admin` — anyone who can actually see the vendor on some surface.
- [ ] Enforce in `core/vendor_ownership.py` beside `_active_user_or_404` — same reasoning as the disabled-account check there ("an ownership nobody can exercise"), one place for both mutations (`set_additional_owners`, `transfer_main_ownership`) and both surfaces (portal + internal `PATCH owner_id`).
- [ ] Filter the pickers to qualifying users: portal `GET /portal/directory` and the internal owner pickers — the API validation is the gate, the filter is the UX.
- [ ] New-vendor requests already comply (`require_vendor_submit` implies a qualifying role for the requester-becomes-owner path, COM-215) — assert it with a test rather than a second check.
- [ ] Tests: non-qualifying co-owner/transfer target refused 404/422 on both surfaces; directory omits them; requester-owned vendor unaffected.