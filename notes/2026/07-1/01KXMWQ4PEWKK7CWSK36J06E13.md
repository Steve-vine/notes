---
id: 01KXMWQ4PEWKK7CWSK36J06E13
created: 2026-07-16T07:19:36.910331328Z
updated: 2026-07-24T12:49:56.712638Z
type: task
title: Assign issues to users
project: 01KX671DATY39VW6GWK3M2T3DN
number: 87
sprint: syqgx3z
blocked_by:
- 01KXMWPXPN4VQ0H0MXS0J16EVE
label: null
task_status: done
---
Allow an issue to be assigned to a user. The `Issue` model has no assignee field today (greenfield); actor columns like `created_by` are free-text email strings, not FKs.

**Backend:**
- Add nullable `assignee_id` FK → `user.id` on `Issue` (proper FK, not a free-text string). Migration.
- Expose assignee in `IssueRead`; PATCH endpoint to set/clear the assignee. Operator-gated.

**Frontend:**
- Assignee picker on the issue detail page (`IssueDetailPage.tsx`), sourced from the users API.
- Show assignee in the issues list (`IssuesPage.tsx`); optional filter-by-assignee.

Blocked by ISE-85 (needs the assignable-user list). Independent of the Settings UI (ISE-86).