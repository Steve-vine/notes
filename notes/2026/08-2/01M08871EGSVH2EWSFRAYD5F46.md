---
id: 01M08871EGSVH2EWSFRAYD5F46
created: 2026-08-17T16:17:30.064735Z
updated: 2026-08-17T19:26:25.030775Z
type: task
title: Access section — new app roles and nav gating
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 243
sprint: s5gwx0s
blocked_by:
- 01M0885AJ0E38GKHXS8ADN8T1T
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The ADR 0026 pattern applied to the new section, so Access is a real permission boundary (directory-write screens must never leak to `viewer`).

* **Backend**: new roles in `models/user.py` `Role` enum — working set: `access_manager` (raise/approve/validate changes, manage the matrix, run campaigns; approver-≠-requester and validator-≠-requester still apply within the role), `access_engineer` (raise **expedited** changes that execute immediately — the break-glass role from the 2026-08-17 amendment; cannot validate their own changes; grant sparingly, infra engineers only), and `access_reviewer` (attest own recert items only); capability frozensets + `can_*` properties; migration adding the enum values to `user_role` (add-only — remember the `postgresql.ENUM(create_type=False)` cross-migration gotcha); `require_access_read` / `require_access_write` / `require_access_expedite` dependencies in `core/auth.py` on every `api/v1` router this sprint adds. Admin retains everything, as ever.
* **Frontend**: `Access` added to the `NavSection` union + `NAV_SECTIONS` in `components/nav.ts`; routes in `App.tsx` under `<RequireSection section="access">` — **and add the paths to the placeholder exclusion list at the bottom of `App.tsx`, or the real routes are shadowed by `<Placeholder>`**; `permissionsFor()` in `auth/hooks.ts` mirrors the backend capabilities (including the expedited-submit affordance).
* Connection config stays admin-only under Admin ▸ Integrations — configuring the credential and using the workflows are different privileges.

Small task, but it fronts the whole sprint's UI and the role names belong in ADR 0045's vocabulary section. Refs: ADR 0045, 0026, 0017; the vendor-roles precedent (ADR 0039/0043).