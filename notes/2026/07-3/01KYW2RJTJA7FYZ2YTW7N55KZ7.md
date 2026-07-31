---
id: 01KYW2RJTJA7FYZ2YTW7N55KZ7
created: 2026-07-31T12:35:38.450469Z
updated: 2026-07-31T12:36:15.987814Z
type: task
title: ise.cool custom domain + Cloudflare Web Analytics
project: 01KX671DATY39VW6GWK3M2T3DN
number: 410
sprint: sp3en5k
blocked_by:
- 01KYW2R7TS6MB4CDYM27ESG7S6
assignee: steve
label:
- chore
priority: medium
task_status: backlog
---
Wire the Worker to `ise.cool` as a custom domain (zone already registered and managed in the personal Cloudflare account); serve or redirect `www` → apex. Enable Cloudflare Web Analytics for the site and add the beacon snippet to the base layout.

**Acceptance:** https://ise.cool serves the site over TLS; analytics dashboard receiving page views.

Depends on ISE-408.