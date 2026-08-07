---
id: 01KYW2RJTJA7FYZ2YTW7N55KZ7
created: 2026-07-31T12:35:38.450469Z
updated: 2026-08-07T10:35:11.10074Z
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
- id: 01KYW6XZ6RAZYW5S2ZYEK60WCH
  author: Steve Vine
  at: 2026-07-31T13:48:29.271832Z
  text: 'Domain half verified live 2026-07-31: https://ise.cool and https://www.ise.cool both serve the site over TLS (custom domains attached by the deploy; DNS managed by Cloudflare; missing paths serve the branded 404 after provisioning settled — initial 1104/500s were transient). Remaining for acceptance: Steve enables Web Analytics for the ise.cool zone in the dashboard (automatic injection, no repo change).'
- id: 01KYW78VQS7E20B2CHQM8CVZ9M
  author: Steve Vine
  at: 2026-07-31T13:54:26.169718Z
  text: Closed by Steve 2026-07-31. ise.cool + www live over TLS with the branded 404. Web Analytics enablement (dashboard toggle, automatic injection) sits with Steve account-side — no repo change involved.
assignee: steve
priority: medium
task_status: done
---
Wire the Worker to `ise.cool` as a custom domain (zone already registered and managed in the personal Cloudflare account); serve or redirect `www` → apex. Enable Cloudflare Web Analytics for the site and add the beacon snippet to the base layout.

**Acceptance:** https://ise.cool serves the site over TLS; analytics dashboard receiving page views.

Depends on ISE-408.