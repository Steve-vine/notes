---
id: 01M0313XDNMV364QN18S8MNTRJ
created: 2026-08-15T15:37:15.445766Z
updated: 2026-08-15T18:09:48.358716Z
type: task
title: 'Vendor owner: requester becomes initial owner + assignable to any user'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 215
sprint: sbph5q5
comments:
- id: 01M039V3T9NABMA2ZHWNAAA84E
  author: Steve Vine
  at: 2026-08-15T18:09:44.265175Z
  text: |-
    Done — PR #212 (feature/com-215-vendor-owner-directory, stacked on #211). All checklist items landed.

    GET /users/directory returns id + name + job_title for active users only, gated by a new `is_internal` capability rather than reusing can_read_library. Those two role sets have identical members today, but that's coincidence not definition — and models/user.py already warns people not to "fix" library-read for consistency, so borrowing it would have coupled the directory's audience to a decision nobody made about it. It's correctly permissive too: a vendor-manager who also holds a portal account still reaches it (there's a test).

    The ownership quirk you flagged is in, and the test states it explicitly: a portal requester with no internal vendor role owns a vendor they can only see through the portal.

    **One thing you should know about**, because it cost me a debugging cycle and will bite again: my first version of useUserDirectory derived `enabled` from usePermissions() (`!isPortalOnly`). That made PortalRouting's login test fail about half the time. Roles come from the `me` query, which is invalidated on sign-in, so a permissions-derived guard is briefly wrong during exactly the window a portal user is being routed — it fired a request the API refuses and perturbed the timing. That test's own comment warns about the stale-roles window; I walked into it anyway. Fixed by taking `enabled` from the caller, with portal-capable callers passing useIsPortal() (context, never stale). Verified 4/4 clean in isolation and two clean full runs.

    Separately: the two portal tests (PortalRouting login, PortalVendorDetailPage linked-risk) intermittently fail under full-suite parallelism and pass in isolation. That predates this work — I saw it in sprint 32 too. Might be worth a task to make them load-tolerant.

    Backend 381 integration passing; frontend 273. OpenAPI regenerated. No migration.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Owner assignment is self-only in practice: the backend accepts any `owner_id` (`_validate_owner` just checks existence), but `GET /users` is admin-only, so the details card can only offer "Assign to me" — and renders non-self owners as just "Assigned" because it cannot resolve names. Nothing sets an owner at request time, so portal-requested vendors are born unowned.

- [ ] **User directory endpoint**: lightweight `GET /users/directory` — id, name (+ job title) of **active** users, readable by any authenticated internal user. Deliberately narrower than the admin users API (no emails/roles/status management). OpenAPI regenerated.
- [ ] **Requester = initial owner**: `vendor_requests.submit` (kind `new_vendor`) sets `owner_id = user.id` on the created vendor. Accepted quirk (noted 2026-08-15): a portal requester with no internal vendor role owns a vendor they can only see through the portal — owner is accountability metadata, not access.
- [ ] **Frontend owner picker** (`vendors/detail/cards.tsx` details card): replace the "Assign to me" button with a searchable Select over the directory (keep an "Assign to me" shortcut); owner label shows the actual user's name instead of "Assigned"; clear/unassign stays.
- [ ] Vendors register "owner" filter/labels resolve names via the directory where shown.
- [ ] Out of scope but unlocked: risks (and other owner pickers) have the same self-only limitation — the directory endpoint is the shared enabler; adopt there in a later task.
- [ ] Tests: directory gating (portal-only role cannot reach it; internal roles can), requester lands as owner on submission, owner update to another user, name resolution in the card.