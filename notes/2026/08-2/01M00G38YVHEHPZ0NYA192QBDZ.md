---
id: 01M00G38YVHEHPZ0NYA192QBDZ
created: 2026-08-14T16:01:19.835337Z
updated: 2026-08-14T20:04:32.105778Z
type: task
title: Dashboard renders blank for an Admin account
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 203
order: 1.0
sprint: sbph5q5
comments:
- id: 01M00M5DHZ7253J4NA8EJVRGF5
  author: Steve Vine
  at: 2026-08-14T17:12:24.380463Z
  text: |-
    Root cause found and fixed. PR #199, merged to main.

    Neither candidate in the original write-up was the whole story — it was both of them interacting. RequireOverview gated the Overview outlet on `isFetching`, which react-query sets for any refetch, not just the first load. DashboardPage reads usePermissions() for its vendor tile (added by COM-187), so mounting the page made the `me` query refetch, which blanked the outlet, which unmounted the page, whose remount refetched again — an unbounded loop. That is the "since the Vendor Portal work" timing: the vendor tile put the `me` observer on the dashboard in COM-187, RequireOverview added the isFetching guard in COM-194, and neither alone loops.

    Confirmed before changing anything by counting /auth/me fetches while the page sat idle: 2 more every 200ms, unbounded.

    Fix: guard on "no user yet" rather than "fetching". That still holds the post-login redirect until roles are known (the case the isFetching guard was reaching for, where isLoading is already false) without unmounting a subtree that is already on screen.

    Worth knowing: three tests in PortalRouting.test.tsx stubbed /api/v1/dashboard with `[]`, which is not a shape the API can return and crashes the page on avg_maturity.toFixed. That was hidden only because the loop stopped the page staying mounted. They now use a contract-shaped fixture, and the "Dashboard" assertions target the heading, since the sidebar nav item matches that text too once the page really renders.

    Regression test counts /auth/me fetches while idle — asserting the page renders would not catch it, because the text flickers in and out and findByText passes while the loop spins. Verified failing on the unfixed code. Full frontend suite green at 239 tests.

    Not yet deployed — staging release goes out once all four sprint tasks are in Review.
assignee: steve
label:
- bug
priority: high
task_status: done
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