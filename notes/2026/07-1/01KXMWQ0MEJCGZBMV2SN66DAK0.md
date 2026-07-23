---
id: 01KXMWQ0MEJCGZBMV2SN66DAK0
created: 2026-07-16T07:19:32.750290926Z
updated: 2026-07-23T19:50:30.163818Z
type: task
title: User management settings section (UI)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 86
sprint: syqgx3z
blocked_by:
- 01KXMWPXPN4VQ0H0MXS0J16EVE
label: null
task_status: done
---
Add a **Users** section to the Settings page (`SettingsPage.tsx`), admin-only, consuming the user management API (ISE-85). No user-management UI exists today — greenfield.

- List users: email, name, roles, status (enabled/disabled), last login.
- Enable / disable a user.
- Follow the existing Settings card pattern (Integrations, AI Models cards; `hasRole(user, 'admin')` gating).

Blocked by ISE-85 (needs the users API).