---
id: 01KX95A9VJ2RR4GKGMEM80RECN
created: 2026-07-11T17:59:00.210485815Z
updated: 2026-07-24T07:17:40.857682Z
type: task
title: CI — retry the staging deploy smoke check
project: 01KX671DATY39VW6GWK3M2T3DN
number: 34
comments:
- id: 01KX99RVE5FJ976460A0YRP6TA
  author: Steve Vine
  at: 2026-07-11T19:16:51.26972786Z
  text: 3rd consecutive occurrence on the ISE-29 staging deploy (after ISE-27, ISE-26) — same curl (7) TCP-connect timeout to ise-api:8000; Helm upgrade + rollout succeeded and pods verified 1/1 healthy each time. It's now reddening essentially every staging deploy, which erodes the signal from that job — bumping priority to high. Worth doing before Sprint 3 closes.
- id: 01KX9D1P7K5FV2Y0MXKMZTP602
  author: Steve Vine
  at: 2026-07-11T20:14:06.578844324Z
  text: 'Development complete on feature/ise-034-smoke-retry. PR #31: https://github.com/Steve-vine/ise/pull/31. Root cause: the deploy-staging Smoke check''s /healthz curl was unguarded + un-retried — no --connect-timeout (a stalled TCP connect hung ~70s) and no retry loop, so a single transient blip failed the whole step under set -e (readyz + public-URL curls already retried; healthz didn''t). Fix: added --connect-timeout/--max-time to every curl (stall fails fast → loop retries) and wrapped /healthz in its own bounded retry loop (10×5s) with a final assertion. Helm upgrade + Rollout status still gate genuine readiness, so only false reds are removed — a persistent failure still fails the step (verified: simulated flow under bash -eo pipefail — flaky-then-ok exits 0, always-fail trips the assert exit 1). PR CI fully green. Merged to staging (b38f66b) — the deploy carrying the fix ran the NEW smoke check: Helm upgrade + Rollout status + Smoke check ALL success, overall run green. First fully-green staging deploy in 4 attempts (ISE-27/26/29 all reddened here). Awaiting merge clearance. Note: CI-only change, no app/UI surface to smoke test — verification is the green staging deploy above.'
- id: 01KXAHQ9N2Y0MCXNJ0V95EAYQE
  author: Steve Vine
  at: 2026-07-12T06:55:03.330407654Z
  text: 'Merged. PR #31 merged to main (996b44f), branch deleted. Belt-and-braces main run green. Done. Future staging deploys should no longer false-red on the smoke check.'
assignee: steve
label: null
priority: high
task_status: done
---
The `deploy-staging` job's "Smoke check" step curls the in-cluster ise-api service once and has intermittently failed with `curl: (7) Failed to connect to ise-api.ise.svc.cluster.local:8000 after ~71s: Couldn't connect to server` — a transient TCP-connect flake between the ARC runner and the ClusterIP service. Observed on the ISE-27 and ISE-26 staging deploys; both times Helm upgrade + Rollout status succeeded and pods were verified healthy, so it's the smoke curl, not the app.

Fix: wrap the smoke curl in a bounded retry loop (e.g. ~5 attempts with a short backoff) before failing, same class of hardening as the ISE-20 append-only-check DNS retry. Keep the overall step timeout sane. Reference the CI pattern in CLAUDE.md / Compass ci.md.

Note: staging deploys are allowed to go red (per CLAUDE.md), so this is quality-of-life to stop false reds, not a release blocker.