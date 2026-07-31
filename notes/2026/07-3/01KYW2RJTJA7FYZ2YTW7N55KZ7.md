---
id: 01KYW2RJTJA7FYZ2YTW7N55KZ7
created: 2026-07-31T12:35:38.450469Z
updated: 2026-07-31T13:12:24.64643Z
type: task
title: ise.cool custom domain + Cloudflare Web Analytics
project: 01KX671DATY39VW6GWK3M2T3DN
number: 410
sprint: sp3en5k
blocked_by:
- 01KYW2R7TS6MB4CDYM27ESG7S6
comments:
- id: 01KYW4VXA62YQ9QM3JMD2AFG8G
  author: Steve Vine
  at: 2026-07-31T13:12:24.646287Z
  text: |-
    Built on feature/ise-410-domain-analytics (PR #8 → main, squash-merged): custom-domain routes for ise.cool and www.ise.cool in wrangler.jsonc — Cloudflare attaches the Worker to both hostnames and manages DNS records on the next successful deploy.

    IN REVIEW pending the deploy-pipeline secrets (ISE-408). Web Analytics: no code needed — once the site is live on the proxied custom domain, enable Web Analytics for the ise.cool zone in the dashboard with automatic injection (keeps the beacon token out of the repo). Acceptance = https://ise.cool over TLS + analytics receiving.
assignee: steve
label:
- chore
priority: medium
task_status: review
---
Wire the Worker to `ise.cool` as a custom domain (zone already registered and managed in the personal Cloudflare account); serve or redirect `www` → apex. Enable Cloudflare Web Analytics for the site and add the beacon snippet to the base layout.

**Acceptance:** https://ise.cool serves the site over TLS; analytics dashboard receiving page views.

Depends on ISE-408.