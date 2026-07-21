---
id: 01KX8GXHM8QXJ94PXXAFP22MQ2
created: 2026-07-11T12:02:30.664509286Z
updated: 2026-07-21T09:53:41.585546Z
type: task
title: Harden CI migration append-only check against transient DNS
project: 01KX671DATY39VW6GWK3M2T3DN
number: 20
sprint: sdm5e08
comments:
- id: 01KX8HXSQZ3Y0HDGK5TKC9YJ1B
  author: Steve Vine
  at: 2026-07-11T12:20:07.551674513Z
  text: 'Development complete on feature/ise-020-ci-dns-retry. PR #21: https://github.com/Steve-vine/ise/pull/21. Wrapped the append-only check''s git fetch in a 5-attempt retry loop with 5s backoff (matches the image pre-pull pattern), fails closed if all attempts fail. actionlint clean, retry logic simulated locally (2 induced failures → recovers), and the modified step ran green against itself on the PR and staging. CI-only change, no app surface. Awaiting merge clearance.'
- id: 01KX8KQ7DWTBABH1J0VD133FXW
  author: Steve Vine
  at: 2026-07-11T12:51:29.340165643Z
  text: 'Smoke tests passed (CI-only change). PR #21 merged to main (d77116e), branch deleted. Belt-and-braces main run green with the hardened append-only step. Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
The append-only check's `git fetch --depth=50 origin main` has no retry and flaked twice on transient DNS (Could not resolve host: github.com) during Sprint 2, reddening a required check. Wrap the fetch in a retry loop (as the image pre-pull step already does). Small hardening; do early.