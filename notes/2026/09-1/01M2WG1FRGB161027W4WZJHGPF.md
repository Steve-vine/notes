---
id: 01M2WG1FRGB161027W4WZJHGPF
created: 2026-09-19T09:30:29.008069Z
updated: 2026-09-24T20:29:37.749007Z
type: task
title: A Compass upgrade is one number — the chart's image tags default to its own version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 723
sprint: stek6vx
comments:
- id: 01M2WWV3F0E1GWQFS6VZAN1SRG
  author: Steve Vine
  at: 2026-09-19T13:14:11.296401Z
  text: |-
    Merged to main 2026-09-19 as 573773c (PR #734). Unreleased — takes effect from the release after 0.3.0.

    Image tags default to empty and fall back to `.Chart.AppVersion`; explicit tags still win (staging untouched); from a checkout the tag is `0.0.0-dev`, which exists nowhere. New `scripts/ci/check-chart-image-tags.sh` in the chart job asserts all three against the packaged chart; CI renders no longer pin a probe tag. Install guide, Release body, RELEASE.md and the production pointer page lose the two `--set` flags.

    Devops repo: readme "Upgrading Compass" and the values-file header are edited in `~/code/devops.application.compass` but NOT committed (Steve owns commits there). They say: the upgrade off 0.3.0 is the last three-number one — bump `targetRevision` and delete `image.tag`, `frontend.image.tag` and the `clientMaxBodySize` line in the same change; left behind, the pinned tags keep winning and a new chart would run 0.3.0 images against new migrations.
assignee: steve
label:
- improvement
priority: medium
task_status: done
tech: null
---
Upgrading production today means changing the same release number in three places: the Argo CD Application's `targetRevision`, and `image.tag` + `frontend.image.tag` in `envs/prod-uk-compass-app.yaml`. They are the same number by construction (ADR 0071 §5: chart version = app version), so two of the three are busywork and a place to get it wrong — a chart at 0.4.0 running 0.3.0 images is a migration mismatch waiting to happen.

**Do**: `image.tag` and `frontend.image.tag` default to empty, and the image helpers fall back to `.Chart.AppVersion`. The release already packages the chart with `--app-version` = the version, so a published chart pulls its own images with no tag set. An explicit tag still wins (staging pins `staging-*` tags from CI). The placeholder `set-by-release` goes; a local `helm install chart/` from a checkout then resolves to `0.0.0-dev`, which exists nowhere and fails at pull exactly as the placeholder did — keep that property and say so in `values.yaml`.

Update `chart/README.md` (the install and upgrade commands lose their two `--set` flags), the evaluation recipe, the CI render shapes, and the devops repo's values file and readme.

**Acceptance**: `helm template` of the packaged chart at version X with no image values renders both images at tag X; staging's explicit tags still win; a production upgrade is a one-line change to `targetRevision`.