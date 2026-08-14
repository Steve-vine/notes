---
id: 01M00G38YVHEHPZ0NYA192QBDZ
created: 2026-08-14T16:01:19.835337Z
updated: 2026-08-14T16:01:19.835337Z
type: task
title: Dashboard renders blank for an Admin account
label: bug
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 203
---
**Reported by Steve, 2026-08-14.** Since the Vendor Portal work, signing in with an **Admin** account and going to the Dashboard shows a **blank page**. Regression — the page used to render.

**To establish first**
* Is it blank (nothing painted) or an error boundary / empty state? Check the browser console for a render crash and the network tab for a failing/403 dashboard query.
* Which build first shows it — bisect across the portal PRs (#186 COM-194, #187 COM-195) and the vendor dashboard tile (#178 COM-187).
* Does it reproduce for non-admin operator roles (assessor/viewer), or admin only?

**Candidate causes (unverified — starting points, not a diagnosis)**
1. `RequireOverview` in `app/frontend/src/App.tsx:86` gates the whole Overview outlet on `useCurrentUser()` and renders `null` while `isFetching`. `isFetching` is true on *any* refetch, not just the first load, so a background refetch of the `me` query blanks `/dashboard` rather than leaving the page up. `LandingRedirect` (`App.tsx:68`) shares the pattern. Both guards were deliberately written that way for the portal-only redirect (ADR 0040 §2), so any fix has to keep a portal-only user off the dashboard.
2. A render crash inside `DashboardPage` — the vendor dashboard tile (COM-187) is the newest thing on that page, and admin sees every tile, which would fit an admin-only symptom.

**Done when:** an Admin sees the Dashboard again, the portal-only redirect still works, and there's a regression test covering the admin-loads-dashboard path.

Refs: ADR 0040, 0026, 0039.