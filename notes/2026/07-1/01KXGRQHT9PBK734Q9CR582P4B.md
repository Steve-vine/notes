---
id: 01KXGRQHT9PBK734Q9CR582P4B
created: 2026-07-14T16:52:58.31301758Z
updated: 2026-07-14T16:53:08.863830133Z
type: task
title: 'Admin: users, API tokens, companies'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 20
sprint: sz3kacg
comments:
- id: 01KXGRQW3Z4BPFACM0QVG9D1YJ
  author: Steve Vine
  at: 2026-07-14T16:53:08.863737155Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 18:23 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/22

    All four checklist items delivered:
    - **User management** — new admin-only `/api/v1/users` (list/create/patch) + a Users tab: create with an initial password, inline role change, enable/disable. "Disable" flips status (no hard delete); an admin can't change their **own** role/status (self-lockout guard).
    - **API token management** — a Tokens tab over the existing self-service tokens API: create (plaintext shown **once**), view, revoke.
    - **Company management + switcher backing data** — a Companies tab over the existing companies API: create/edit/set-default/archive; mutations invalidate `['companies']` so the top-bar switcher refreshes immediately.
    - **Admin section gated to admin** — the sidebar hides Admin from non-admins (`AppLayout`) and the page itself guards (`Admins only`). The DEV-405 maturity rubric moved into a tab.

    Backend was small — only the users API was new; companies and tokens APIs already existed.

    Verification: backend ruff/mypy(src) clean, 27 unit + 48 integration pass; frontend eslint/tsc/prettier clean, 18 vitest pass. Branched off `main`.

    Two notes: (1) initial-password-on-create is the pragmatic choice until email/SMTP lands (DEV-417 — invites/reset). (2) Left at In Review for your eyes on the Admin UX; say the word to merge.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Administrative surfaces per ADR 0007/0009/0017.

- [ ] User management UI (create/disable, assign role admin/editor/viewer)
- [ ] API token management (create, view, revoke)
- [ ] Company management + the global company switcher backing data
- [ ] Admin section gated to the admin role

Depends on: Auth, Company entity, Frontend app shell. Refs: ADR 0007, 0009, 0017.

---
*Migrated from Linear [DEV-406](https://linear.app/stevevine/issue/DEV-406/admin-users-api-tokens-companies) · created 2026-06-13 · completed 2026-06-16*  
*Related to (Linear): DEV-405, DEV-417, DEV-402, DEV-393*