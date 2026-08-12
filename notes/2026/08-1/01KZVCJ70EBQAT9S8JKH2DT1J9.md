---
id: 01KZVCJ70EBQAT9S8JKH2DT1J9
created: 2026-08-12T16:23:22.89456Z
updated: 2026-08-12T16:23:22.89456Z
type: task
title: Login flash on hard-refresh of authenticated routes
priority: medium
assignee: steve
label:
- follow_up
- tech_debt
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 163
---
Pre-existing issue, made more visible by 008b. `shellRoute.beforeLoad` runs the auth check client-side after the JS bundle parses, so on hard-refresh of any authenticated route the login route briefly renders before the redirect resolves. Fix is non-trivial — render a loading splash (or `null`) during initial auth resolution so the login route doesn't flash. Same pattern as the dashboard issue from Brief 005.

Source: Obsidian To Do § From Brief 008b.

---

Imported from Linear [DEV-46](https://linear.app/stevevine/issue/DEV-46/login-flash-on-hard-refresh-of-authenticated-routes) · parent DEV-14