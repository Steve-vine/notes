---
id: 01M3AC183VR6KAQJCJNPB6MTW6
created: 2026-09-24T18:49:48.923884Z
updated: 2026-09-24T21:00:36.600318Z
type: task
title: The repository moved to RootCause-IT — documentation, chart and workflow follow it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 744
sprint: s3nfes0
comments:
- id: 01M3AFWGT1EMBN2619VEQGBYN9
  author: Steve Vine
  at: 2026-09-24T19:57:08.289799Z
  text: |-
    Done — PR #755, merged to main (ee20394).

    Everything in the tree that named the old location now names `RootCause-IT/compass`: the chart's home and sources, its README's install commands and releases link, the default image repositories, where a release publishes (`release.yml`), the infra READMEs and RELEASE.md, the deployer RBAC comment. The runner scale set's URL went ahead in COM-745. ADRs 0020, 0071 and 0073 carry a dated "the repository moved" note rather than a rewrite.

    **Left for the next release, as agreed:** the published images and chart stay at `ghcr.io/steve-vine/compass/…` and production keeps pulling them. The first `vX.Y.Z` after the move publishes under `ghcr.io/rootcause-it/compass/…`; then set those packages public (ADR 0071) and move the Argo CD repo's image and chart references in the same upgrade. Until then, a fresh install of the chart from `main` with default values would point at packages that do not exist yet — staging (zot) and production (the published chart) are unaffected.

    Still open on GitHub's side, not in this task: branch protection on `main` needs the org on GitHub Team.

    Nothing to smoke-test in the app.
assignee: steve
label:
- chore
priority: medium
task_status: done
---
On 2026-09-24 the repository moved from `Steve-vine/compass` to **`RootCause-IT/compass`** (`git@github.com:RootCause-IT/compass.git`). Local checkouts were repointed the same day. Everything that writes the old location down needs to follow.

**Documentation and config in the repo** (`grep -rniE "steve-vine/compass|github.com/steve-vine"` finds them):
- `chart/Chart.yaml` — `home` and `sources`
- `chart/README.md` — the `helm install`/`upgrade` OCI references and the releases link
- `chart/values.yaml` — `image.repository` for backend and frontend (`ghcr.io/steve-vine/compass/…`)
- `.github/workflows/release.yml` — `GHCR` and `CHARTS` (where a release publishes)
- `scripts/infra/RELEASE.md`, `scripts/infra/aws-staging/README.md`, `scripts/infra/production/README.md`, `scripts/infra/ci-deployer-rbac.yaml` (comment)
- `scripts/infra/arc-compass-runners-values.yaml` — `githubConfigUrl` (**live**: the self-hosted runner scale set on g5 registers against this URL; GitHub redirects a transferred repo, but the values should say the truth and the listener re-rolled — see the runner-image memo)
- ADRs 0020, 0071, 0073 mention the old package names — append-only: add a dated note rather than rewriting

**Images and chart — next release, not now.** The published packages `ghcr.io/steve-vine/compass/{backend,frontend}` and `…/charts/compass` stay where they are and production keeps pulling them. The next `vX.Y.Z` release publishes under `ghcr.io/rootcause-it/compass/…` once `release.yml` and `chart/values.yaml` point there; the GHCR packages under the new org need their visibility set (public, as ADR 0071 decided) after the first publish; and the Argo CD repo `devops.application.compass` then moves its image and chart references to the new location in the same upgrade.

Also check: the GitHub App / token the ARC runners and `gh` on g5 use is installed on the **RootCause-IT** organisation, and branch protection on `main` survived the transfer (it should — protection moves with the repo).