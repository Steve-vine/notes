---
id: 01KYW2RJTJA7FYZ2YTW7N55KZ7
created: 2026-07-31T12:35:38.450469Z
updated: 2026-07-31T12:35:38.450469Z
type: task
title: ise.cool custom domain + Cloudflare Web Analytics
assignee: steve
priority: medium
label: chore
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 410
---
Wire the Worker to `ise.cool` as a custom domain (zone already registered and managed in the personal Cloudflare account); serve or redirect `www` → apex. Enable Cloudflare Web Analytics for the site and add the beacon snippet to the base layout.

**Acceptance:** https://ise.cool serves the site over TLS; analytics dashboard receiving page views.

Depends on ISE-408.