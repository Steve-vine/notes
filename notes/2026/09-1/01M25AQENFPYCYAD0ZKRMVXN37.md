---
id: 01M25AQENFPYCYAD0ZKRMVXN37
created: 2026-09-10T09:35:05.391989Z
updated: 2026-09-10T09:53:18.881552Z
type: task
title: The chart is published with the release, at the release's version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 652
sprint: stek6vx
blocked_by:
- 01M25AQ58J5128F6AZMKGWV4NC
comments:
- id: 01M25BR9BVJN66C3568RPX2S8X
  author: Steve Vine
  at: 2026-09-10T09:53:01.302736Z
  text: 'PR #656 open, stacked on #655: https://github.com/Steve-vine/compass/pull/656 — chart packaged and pushed at the release version to `oci://ghcr.io/steve-vine/compass/charts` (package `compass/charts/compass`, chart keeps its name), Chart.yaml placeholders, values.yaml defaults → GHCR with a `set-by-release` sentinel, values-prod cleaned, README "Install from a release". Verified locally: lint, package at 0.1.0, prod render pins ghcr refs and `helm.sh/chart: compass-0.1.0`.'
- id: 01M25BRTH1TWDC4GA30FT6A7MY
  author: Steve Vine
  at: 2026-09-10T09:53:18.881038Z
  text: 'PR #656 open, stacked on #655: https://github.com/Steve-vine/compass/pull/656 — chart packaged and pushed at the release version to `oci://ghcr.io/steve-vine/compass/charts` (package `compass/charts/compass`, chart keeps its name), Chart.yaml placeholders, values.yaml defaults → GHCR with a `set-by-release` sentinel, values-prod cleaned, README "Install from a release". Verified locally: lint, package at 0.1.0, prod render pins ghcr refs and `helm.sh/chart: compass-0.1.0`.'
assignee: steve
label:
- feature
priority: high
task_status: review
---
The same release that copies the images publishes the Helm chart to GHCR as an OCI artifact, so production installs with one command naming one version:

```
helm install compass oci://ghcr.io/steve-vine/compass/chart --version 1.4.0 -f values-production.yaml
```

**What happens** (a step in `release.yml`, after the image copy succeeds)

- `helm package chart/ --version <version> --app-version <version>` — the checked-in `Chart.yaml` version stays a placeholder; the release decides the number. Chart version = app version, always.
- `helm push` to `oci://ghcr.io/steve-vine/compass` (package name `chart`, from `Chart.yaml` `name` — rename the chart or push under the path that yields `compass/chart`; decide in the PR, record in the README). Login with `GITHUB_TOKEN`; retry loop like the images.
- Guard: refuse if that chart version already exists.
- The GitHub Release body includes the `helm install` line.

**Also**: `chart/values.yaml` image defaults become `ghcr.io/steve-vine/compass/backend` / `…/frontend` with `tag: set-by-release`-style sentinel so an install without pinning fails loudly (the staging overlay keeps zot). `values-prod.yaml` — rename to `values-production.yaml`? — loses its zot references and its `imagePullSecrets` comment (public pull needs none); the rest of that file is the next sprint task's business.

**Acceptance**: after a release, `helm show chart oci://ghcr.io/steve-vine/compass/chart --version <v>` works anonymously off the LAN and reports `appVersion: <v>`; `helm template` against it with `values-staging.yaml`-shaped input renders the same manifests as `chart/` at that commit.