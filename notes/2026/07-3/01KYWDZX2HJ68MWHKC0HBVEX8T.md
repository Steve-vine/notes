---
id: 01KYWDZX2HJ68MWHKC0HBVEX8T
created: 2026-07-31T15:51:52.65797Z
updated: 2026-08-05T13:39:24.394439Z
type: task
title: ise.cool serves stale HTML after deploy — add a cache rule or purge on deploy
project: 01KX671DATY39VW6GWK3M2T3DN
number: 445
sprint: sp3en5k
comments:
- id: 01KYWG0AQ79BH5NB7MSS831PAH
  author: Steve Vine
  at: 2026-07-31T16:27:03.78381Z
  text: |-
    Built on feature/ise-445-cache-headers — PR #34, left OPEN for review.

    Took a third option not in the original task: a `public/_headers` file, which wrangler uploads as a deployment module for static assets. This is a repo-side fix needing no dashboard access and no token permission change, so it can ship through the normal pipeline.

    - HTML (and everything under the catch-all): `public, no-cache, must-revalidate` — the deploy must be visible immediately, and pages aren't content-addressed so a stale copy is indistinguishable from a fresh one.
    - `/_astro/*`: `public, max-age=31536000, immutable` — content-hashed filenames, so a changed file is a different URL. Bonus perf win: today they're `max-age=0, must-revalidate` and revalidate on every page view.

    GOTCHA found while verifying, worth remembering: `_headers` rules are ADDITIVE, not override. The first attempt emitted `public, no-cache, must-revalidate, public, max-age=31536000, immutable` on assets — one contradictory header. Fixed with the `! Cache-Control` unset operator (note the operator is literally "! " with the trailing space) in the asset rule. Both commits are on the branch.

    Verified empirically on the PR preview, not just reasoned about: /concepts/estate/ → no-cache; /_astro/print.*.css → a single clean immutable value; /favicon.svg → no-cache.

    STILL IN REVIEW, NOT DONE — the acceptance criterion can only be met post-merge. The stale pages were ALREADY served max-age=0, must-revalidate and still returned cf-cache-status: HIT, so the edge appeared to skip revalidation entirely; `no-cache` is the right unambiguous first move but is not proven until a real deploy is tested. On merge, run the test: change one page's text, merge, and check the body (not the headers) is fresh within seconds. If it is still stale, the zone-level Cache Rule from the task description is required, and that needs Steve — dashboard access or a token with Zone → Cache Rules, neither of which CI has.
assignee: steve
priority: medium
task_status: done
---
Freshly-deployed pages can serve the previous build from Cloudflare's edge cache for an unpredictable window.

**Observed 2026-07-31** (integration-docs release, PRs #9–#16): immediately after a green deploy, six of the eight rewritten integration pages served the new content but `/integrations/azure/` and `/integrations/webhooks/` still returned the old stub, with `cf-cache-status: HIT`. Nothing was wrong with the build or the deploy — the edge simply held the old HTML. That is a bad property for a docs site: a merge looks live, reads stale, and the person checking can't tell which they're seeing.

**Two fixes, either sufficient:**

1. **Cache rule on the ise.cool zone (recommended)** — bypass cache, or set a very short edge TTL, for HTML documents (`text/html` / paths without a file extension). Astro's JS/CSS/font assets carry content-hashed filenames, so they can and should keep caching normally. No token scope change, no extra pipeline step, and it holds no matter who or what triggers the deploy.
2. **Purge on deploy** — add a purge step to `.github/workflows/deploy.yml` after `wrangler deploy`. Needs the Cloudflare API token to gain **Zone → Cache Purge**, which the current Workers-scoped token does not have — so this one has a manual prerequisite for Steve.

Prefer (1); do (2) as well only if a belt-and-braces purge is wanted.

**Acceptance:** merge a trivial content change, and the new text is served from `https://ise.cool/<changed page>/` within seconds of the deploy going green — verified by response body, not just by cache headers.