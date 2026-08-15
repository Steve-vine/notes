---
id: 01M0313XDNMV364QN18S8MNTRJ
created: 2026-08-15T15:37:15.445766Z
updated: 2026-08-15T15:37:15.445766Z
type: task
title: 'Vendor owner: requester becomes initial owner + assignable to any user'
priority: medium
task_status: todo
assignee: steve
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 215
---
Owner assignment is self-only in practice: the backend accepts any `owner_id` (`_validate_owner` just checks existence), but `GET /users` is admin-only, so the details card can only offer "Assign to me" — and renders non-self owners as just "Assigned" because it cannot resolve names. Nothing sets an owner at request time, so portal-requested vendors are born unowned.

- [ ] **User directory endpoint**: lightweight `GET /users/directory` — id, name (+ job title) of **active** users, readable by any authenticated internal user. Deliberately narrower than the admin users API (no emails/roles/status management). OpenAPI regenerated.
- [ ] **Requester = initial owner**: `vendor_requests.submit` (kind `new_vendor`) sets `owner_id = user.id` on the created vendor. Accepted quirk (noted 2026-08-15): a portal requester with no internal vendor role owns a vendor they can only see through the portal — owner is accountability metadata, not access.
- [ ] **Frontend owner picker** (`vendors/detail/cards.tsx` details card): replace the "Assign to me" button with a searchable Select over the directory (keep an "Assign to me" shortcut); owner label shows the actual user's name instead of "Assigned"; clear/unassign stays.
- [ ] Vendors register "owner" filter/labels resolve names via the directory where shown.
- [ ] Out of scope but unlocked: risks (and other owner pickers) have the same self-only limitation — the directory endpoint is the shared enabler; adopt there in a later task.
- [ ] Tests: directory gating (portal-only role cannot reach it; internal roles can), requester lands as owner on submission, owner update to another user, name resolution in the card.