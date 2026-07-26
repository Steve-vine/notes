---
id: 01KYF6W641KWMHJYDMGZ7BEVPH
created: 2026-07-26T12:37:23.201435Z
updated: 2026-07-26T13:32:33.472706Z
type: task
title: Run a local GitHub Actions cache proxy for the runners
project: 01KX671DATY39VW6GWK3M2T3DN
number: 316
sprint: sr2f21y
assignee: steve
label:
- improvement
priority: high
task_status: active
---
`setup-uv` / `setup-node` cache restores go to GitHub's cache service **over the internet** — a 63MB restore was observed crawling at **0.1 MB/s**, and that starvation caused the `ClusterLink.test.tsx` 5s-timeout flake ([[ise-ci-ryuk-dockerhub-throttle]]). Run a self-hosted, ARC-compatible actions-cache proxy (e.g. a MinIO-backed cache server) on g5 so restores stay on-LAN.

Acceptance: cache restore at LAN throughput; the ClusterLink load-flake stops recurring.