---
id: 01KYW2R7TS6MB4CDYM27ESG7S6
created: 2026-07-31T12:35:27.193434Z
updated: 2026-08-05T12:03:17.392402Z
type: task
title: GitHub Actions deploy pipeline — main → Cloudflare Workers
project: 01KX671DATY39VW6GWK3M2T3DN
number: 408
sprint: sp3en5k
blocked_by:
- 01KYW2Q2N03YTZX0VEAMZAKN9N
comments:
- id: 01KYW4RE389M8NGAY8V9VRKYKP
  author: Steve Vine
  at: 2026-07-31T13:10:30.7604Z
  text: |-
    Built on feature/ise-408-deploy-pipeline (PR #6 → main, squash-merged): push to main → npm ci, lint, format check, build, wrangler deploy via cloudflare/wrangler-action, single-flight concurrency group. Credentials only from repo secrets.

    IN REVIEW, not Done: no Cloudflare secrets exist in the repo yet, so the first deploy run will fail at the wrangler step. Manual step for Steve — create a Workers-scoped API token in the personal Cloudflare dashboard, then:
      gh secret set CLOUDFLARE_API_TOKEN
      gh secret set CLOUDFLARE_ACCOUNT_ID
    and re-run the failed Deploy workflow (or push anything to main). Acceptance = site live on the workers.dev URL.
- id: 01KYW6XT889JJJ416C0RB0BNJB
  author: Steve Vine
  at: 2026-07-31T13:48:24.200158Z
  text: 'DONE — acceptance verified 2026-07-31. Secrets set (first interactive gh secret set via the ! prefix stored an empty token value — reset with --body); Deploy run 30633514064 re-run green: build + wrangler deploy succeeded, site live. NOTE: the API token was pasted into the Claude session, so it should be rolled in the Cloudflare dashboard and the CLOUDFLARE_API_TOKEN secret re-set from a real terminal.'
assignee: steve
label: null
priority: high
task_status: done
---
GitHub Actions workflow: on push to `main` — `npm ci`, `npm run build`, `wrangler deploy` to Cloudflare Workers static assets in the personal Cloudflare account. Cloudflare's built-in git integration is deliberately not used — the pipeline lives in this repo.

`CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID` as GitHub Actions repo secrets. Manual step for Steve: create a Workers-scoped API token in the Cloudflare dashboard — the token never lands in the repo or wrangler config.

**Acceptance:** a merge to `main` automatically deploys the site to its workers.dev URL.

Depends on ISE-403.