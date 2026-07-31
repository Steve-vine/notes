---
id: 01KYWDZX2HJ68MWHKC0HBVEX8T
created: 2026-07-31T15:51:52.65797Z
updated: 2026-07-31T15:52:01.703416Z
type: task
title: ise.cool serves stale HTML after deploy — add a cache rule or purge on deploy
project: 01KX671DATY39VW6GWK3M2T3DN
number: 445
sprint: sp3en5k
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
Freshly-deployed pages can serve the previous build from Cloudflare's edge cache for an unpredictable window.

**Observed 2026-07-31** (integration-docs release, PRs #9–#16): immediately after a green deploy, six of the eight rewritten integration pages served the new content but `/integrations/azure/` and `/integrations/webhooks/` still returned the old stub, with `cf-cache-status: HIT`. Nothing was wrong with the build or the deploy — the edge simply held the old HTML. That is a bad property for a docs site: a merge looks live, reads stale, and the person checking can't tell which they're seeing.

**Two fixes, either sufficient:**

1. **Cache rule on the ise.cool zone (recommended)** — bypass cache, or set a very short edge TTL, for HTML documents (`text/html` / paths without a file extension). Astro's JS/CSS/font assets carry content-hashed filenames, so they can and should keep caching normally. No token scope change, no extra pipeline step, and it holds no matter who or what triggers the deploy.
2. **Purge on deploy** — add a purge step to `.github/workflows/deploy.yml` after `wrangler deploy`. Needs the Cloudflare API token to gain **Zone → Cache Purge**, which the current Workers-scoped token does not have — so this one has a manual prerequisite for Steve.

Prefer (1); do (2) as well only if a belt-and-braces purge is wanted.

**Acceptance:** merge a trivial content change, and the new text is served from `https://ise.cool/<changed page>/` within seconds of the deploy going green — verified by response body, not just by cache headers.