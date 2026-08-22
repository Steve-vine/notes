---
id: 01M0MBNNT8WQTC58S1RENCSW6G
created: 2026-08-22T09:08:48.584157Z
updated: 2026-08-22T09:09:12.413673Z
type: task
title: Vendor ownership requires a qualifying role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 348
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Closes the stranded-owner gap: today owner/co-owner/transfer targets are validated as "active user" only, so someone with no portal access can end up accountable for a vendor — `is_owner()` true, every surface 403, review-due reminders (`tasks/reminders.py`) landing in their digest for a record no screen will show them.

`vendor_user` is granted to most staff but deliberately not all (kitchen assistants, cleaners…), so the rule is: **only role-holders can be made owners**.

- [ ] Qualifying set: `vendor_user`, `vendor_admin`, `admin` — anyone who can actually see the vendor on some surface.
- [ ] Enforce in `core/vendor_ownership.py` beside `_active_user_or_404` — same reasoning as the disabled-account check there ("an ownership nobody can exercise"), one place for both mutations (`set_additional_owners`, `transfer_main_ownership`) and both surfaces (portal + internal `PATCH owner_id`).
- [ ] Filter the pickers to qualifying users: portal `GET /portal/directory` and the internal owner pickers — the API validation is the gate, the filter is the UX.
- [ ] New-vendor requests already comply (`require_vendor_submit` implies a qualifying role for the requester-becomes-owner path, COM-215) — assert it with a test rather than a second check.
- [ ] Tests: non-qualifying co-owner/transfer target refused 404/422 on both surfaces; directory omits them; requester-owned vendor unaffected.