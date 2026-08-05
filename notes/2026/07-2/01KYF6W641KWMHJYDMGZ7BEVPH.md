---
id: 01KYF6W641KWMHJYDMGZ7BEVPH
created: 2026-07-26T12:37:23.201435Z
updated: 2026-08-05T12:33:57.963958Z
type: task
title: Run a local GitHub Actions cache proxy for the runners
project: 01KX671DATY39VW6GWK3M2T3DN
number: 316
sprint: sr2f21y
comments:
- id: 01KYFCHACDCRKPCD27JVCP5N4W
  author: Steve Vine
  at: 2026-07-26T14:16:18.573073Z
  text: |-
    Done — PR #274 (feature/ise-316-cache-proxy, stacked on #272/#273). Cache validated live.

    What was built:
    - github-actions-cache-server (filesystem + sqlite on a 40Gi PVC) deployed in ci-cache (gha-cache, 1/1). Implements the Actions cache v2 protocol that recent runners use.
    - ise-runners point at it via CUSTOM_ACTIONS_RESULTS_URL. The stock actions-runner ignores that env, so the runner image is swapped to the falcondev-oss fork that honours it (you approved this).

    Validated end-to-end: with the redirect live I re-ran the pipeline — backend, frontend and api-types all passed, and the setup-uv/setup-node cache blobs were written to gha-cache's PVC on-LAN, including a ~63MB blob (exactly the "63MB restore" size from the flake report). So restores now stay on-LAN → the ClusterLink starvation root cause is removed.

    One issue found and fixed: CUSTOM_ACTIONS_RESULTS_URL redirects the *entire* Actions results API — cache AND artifacts. The cache server implements cache only, so gitleaks' report upload (the only artifact call in our pipeline) 404'd and failed secret-scan. Fixed with GITLEAKS_ENABLE_UPLOAD_ARTIFACT=false; documented in scripts/infra/ci-cache/README.md that any future upload-artifact step needs revisiting.

    Rollout note: because the runner redirect is cluster-global (it would 404 gitleaks on every branch until the ci.yml fix is everywhere), I rolled the live redirect back to the ISE-314 state for now so the remaining 317-320 PRs run clean. The gha-cache server stays deployed. The redirect is re-applied at the staging release — `helm upgrade ise-runners -f scripts/infra/ise-runners-values.yaml` — once the gitleaks fix is in the combined staging state, and the final staging run validates it with the fix present.

    PR #274 (combined 314+315+316) is fully green on the stock runners.
assignee: steve
label: null
priority: high
task_status: done
---
`setup-uv` / `setup-node` cache restores go to GitHub's cache service **over the internet** — a 63MB restore was observed crawling at **0.1 MB/s**, and that starvation caused the `ClusterLink.test.tsx` 5s-timeout flake ([[ise-ci-ryuk-dockerhub-throttle]]). Run a self-hosted, ARC-compatible actions-cache proxy (e.g. a MinIO-backed cache server) on g5 so restores stay on-LAN.

Acceptance: cache restore at LAN throughput; the ClusterLink load-flake stops recurring.