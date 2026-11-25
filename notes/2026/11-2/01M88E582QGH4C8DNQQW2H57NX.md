---
id: 01M88E582QGH4C8DNQQW2H57NX
created: 2026-11-25T04:06:57.367699Z
updated: 2026-11-25T22:31:48.111899Z
type: task
title: 'Some screens ask for data the account can''t see: dashboard for Analyst and Vendor Admin, portal vendor flags for a requester'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2163
assignee: steve
label:
- bug
priority: low
task_status: todo
---
Seen during the sprint 125/126 round 2 pre-UAT on staging a63d542b2 (25 Nov 2026), and probably older than those sprints. **Not built; for Steve to schedule.**

- The dashboard makes failed requests (403) for E2E Analyst and E2E Vendor Admin, on the risk overview and on checks.
- The portal vendor page makes a failed request (403) for vendor flags for E2E Asset Owner (a portal requester).

## What people should see
Each screen only asks for what the account may see, and hides the parts it can't show, with no failed requests (the same fix as COM-2160 for business services).

## Done when
- No failed requests for those accounts on those screens.
- Consider making the Browser smoke fail on any 403 for every account and screen, if it doesn't already catch these.