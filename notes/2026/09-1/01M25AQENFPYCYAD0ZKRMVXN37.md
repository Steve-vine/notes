---
id: 01M25AQENFPYCYAD0ZKRMVXN37
created: 2026-09-10T09:35:05.391989Z
updated: 2026-09-10T09:35:05.391989Z
type: task
title: The chart is published with the release, at the release's version
priority: high
task_status: todo
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 652
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