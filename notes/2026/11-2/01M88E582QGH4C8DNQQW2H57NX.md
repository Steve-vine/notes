---
id: 01M88E582QGH4C8DNQQW2H57NX
created: 2026-11-25T04:06:57.367699Z
updated: 2026-11-26T00:19:02.633745Z
type: task
title: 'Some screens ask for data the account can''t see: dashboard for Analyst and Vendor Admin, portal vendor flags for a requester'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2163
comments:
- id: 01M8AKGGAGBXY4VYQDTDH6CKEV
  author: Steve Vine
  at: 2026-11-26T00:18:58.000172Z
  text: |-
    Done — PR #2180, merged to main (2ce5d0ae). Goes to staging with the rest of the sprint-0 batch.

    What to look at:
    - **Dashboard, as E2E Analyst or E2E Vendor Admin:** there is no *Risks above appetite* card and no *Evidence Collection* tile, and the page makes no failed requests. Both need View posture, which those roles don't have. E2E Access Manager lacks it too and gets the same fix. Everything else on the dashboard is unchanged. Viewer, Assessor and Admin still see both.
    - **User Portal ▸ Vendors ▸ any vendor, as E2E Asset Owner:** the Flags card still shows the vendor's flags. It no longer asks for the company's whole flag list, so there is no failed request. The internal vendor page does the same for anyone who can't edit the vendor.
    - **Browser smoke:** it already failed a screen on any failed request, 403 included. It missed these for two reasons: the screen an account starts on was never checked on its first load, and no step opened a vendor's record in the portal. Now it checks the Dashboard (or the portal) on first load for every account, and opens the first vendor's record on every tab for the portal account.

    Found while doing this, not changed: the dashboard's *Open gaps* card links to Gaps for everyone, including people who can't open Gaps.

    Technical: the dashboard checks `posture.view` before asking for `/risk-overview` and `/checks`. The Flags card asks for `/vendor-flags` only when editing. `app/e2e`: `crawlMenu` checks the home screen first, and there is a new `crawlPortalVendor` step. No allowed-failure exceptions were added. No migration, no API change.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Seen during the sprint 125/126 round 2 pre-UAT on staging a63d542b2 (25 Nov 2026), and probably older than those sprints. **Not built; for Steve to schedule.**

- The dashboard makes failed requests (403) for E2E Analyst and E2E Vendor Admin, on the risk overview and on checks.
- The portal vendor page makes a failed request (403) for vendor flags for E2E Asset Owner (a portal requester).

## What people should see
Each screen only asks for what the account may see, and hides the parts it can't show, with no failed requests (the same fix as COM-2160 for business services).

## Done when
- No failed requests for those accounts on those screens.
- Consider making the Browser smoke fail on any 403 for every account and screen, if it doesn't already catch these.