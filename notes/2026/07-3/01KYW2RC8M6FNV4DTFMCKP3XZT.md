---
id: 01KYW2RC8M6FNV4DTFMCKP3XZT
created: 2026-07-31T12:35:31.732197Z
updated: 2026-08-05T12:34:23.970482Z
type: task
title: PR preview deployments
project: 01KX671DATY39VW6GWK3M2T3DN
number: 409
sprint: sp3en5k
blocked_by:
- 01KYW2R7TS6MB4CDYM27ESG7S6
comments:
- id: 01KYW4SY8R1Z8FPX38Q5TBTWRC
  author: Steve Vine
  at: 2026-07-31T13:11:20.088004Z
  text: |-
    Built on feature/ise-409-pr-previews (PR #7 → main, squash-merged): on pull_request — lint, format check, build, wrangler versions upload (preview version, no production traffic), then a marker-based PR comment upserted with the workers.dev preview URL.

    IN REVIEW: uses the same CLOUDFLARE_API_TOKEN / CLOUDFLARE_ACCOUNT_ID secrets as the deploy workflow — previews start working (and can be verified on the next PR) once those are added.
- id: 01KYW6XWZ9XRQJX6E60RYA0NRG
  author: Steve Vine
  at: 2026-07-31T13:48:26.98568Z
  text: 'Secrets now in place. The preview run on PR #8 predated the working token, so the workflow hasn''t produced a preview comment yet — acceptance will be verified on the next PR raised against main. Leaving in Review until then.'
- id: 01KYW78R8GABE61K6GX1K4SHH2
  author: Steve Vine
  at: 2026-07-31T13:54:22.607966Z
  text: Closed by Steve 2026-07-31. Workflow is merged and secrets are in place; the preview comment will show up on the next PR raised against main — if it doesn't, reopen this.
assignee: steve
priority: medium
task_status: done
---
Per-PR preview deployments: on `pull_request`, build and `wrangler versions upload` (preview URL, not production), and comment the preview URL on the PR so visual changes are reviewable before merge.

Depends on ISE-408.