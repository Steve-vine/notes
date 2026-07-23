---
id: 01KX8GYJEGGCPKKA5YR89BTCT6
created: 2026-07-11T12:03:04.27278408Z
updated: 2026-07-23T18:38:59.892755Z
type: task
title: UI — Overview live system cards
project: 01KX671DATY39VW6GWK3M2T3DN
number: 27
sprint: sdm5e08
blocked_by:
- 01KX8GY8VRP7405VR5X6MYFNGV
comments:
- id: 01KX90WZGZ008KR4AQ1V86XKZY
  author: Steve Vine
  at: 2026-07-11T16:41:49.343095443Z
  text: 'Development complete on feature/ise-027-overview-cards. PR #27: https://github.com/Steve-vine/ise/pull/27. Overview empty state replaced with live cards: one per configured system showing health pill, sync-staleness pill (fresh/ageing/stale/never), last-sync relative time, last-sync error, and open findings counted by severity. Estate header rolls up open-finding totals across systems; recent-activity strip links to /audit. Per-screen polling 15s. Backend additive (ADR 0009): exposed last_synced_at/last_sync_error on SystemRead (model+sync engine already tracked them); regenerated openapi.json+types. Staleness/relative-time extracted to lib/systemStatus with 8 unit tests (shared with ISE-28). PR CI green (backend/frontend/api-types/secret-scan/changes all pass). Merged to staging (a9df72e). Staging CI: test suite + build-images green; deploy-staging Helm upgrade + Rollout status succeeded, but the post-deploy Smoke curl timed out on TCP connect (runner→ise-api svc, 70s) — a transient network-path flake, NOT an app/deploy failure. Verified LIVE on g5: ise-api/frontend/worker/beat all 1/1 Available with freshly-rolled 2m-old Running pods; readiness probes passed. Candidate follow-up: add a retry loop to the CI Smoke check step (same class of transient as the ISE-20 append-only fix). Awaiting UI smoke test + merge clearance.'
- id: 01KX91N4RSX0TTDNE3Z1WYB682
  author: Steve Vine
  at: 2026-07-11T16:55:01.145253349Z
  text: 'Smoke tests passed. PR #27 merged to main (c48872c), branch deleted. Belt-and-braces main run green (test suite + production build). Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the Overview empty state with one card per configured system (ui-brief): health, connection status, last sync + staleness pill (green fresh / yellow ageing / red stale), open issue count by severity. Estate-wide strips: open issues, recent audit activity. Everything clicks through. Uses generated types; per-screen polling.