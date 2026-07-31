---
id: 01KYW2R7TS6MB4CDYM27ESG7S6
created: 2026-07-31T12:35:27.193434Z
updated: 2026-07-31T12:36:12.37634Z
type: task
title: GitHub Actions deploy pipeline — main → Cloudflare Workers
project: 01KX671DATY39VW6GWK3M2T3DN
number: 408
sprint: sp3en5k
blocked_by:
- 01KYW2Q2N03YTZX0VEAMZAKN9N
assignee: steve
label:
- chore
priority: high
task_status: backlog
---
GitHub Actions workflow: on push to `main` — `npm ci`, `npm run build`, `wrangler deploy` to Cloudflare Workers static assets in the personal Cloudflare account. Cloudflare's built-in git integration is deliberately not used — the pipeline lives in this repo.

`CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID` as GitHub Actions repo secrets. Manual step for Steve: create a Workers-scoped API token in the Cloudflare dashboard — the token never lands in the repo or wrangler config.

**Acceptance:** a merge to `main` automatically deploys the site to its workers.dev URL.

Depends on ISE-403.