---
id: 01M64G1CHKNZZDT7QSDRVFH92V
created: 2026-10-29T18:51:26.643378Z
updated: 2026-10-29T18:51:26.643378Z
type: task
title: 'Install guide and version point at the old registry: releases are now 0.16.0 under ghcr.io/rootcause-it'
task_status: active
priority: high
assignee: steve
label: bug
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 22
---
Since the move to RootCause-IT, Compass releases publish to `ghcr.io/rootcause-it/compass` (chart `oci://ghcr.io/rootcause-it/compass/charts/compass`). The latest release is v0.16.0 (2026-10-20). The site still points everything at `ghcr.io/steve-vine/compass`, where the newest version is 0.7.0. The version lookup, the install commands and the image names are all stale, so a visitor following the install guide gets a version nine releases old.

Fix: point `src/lib/release.ts` (lookup, images, fallback) and every page at the new registry; diff `chart/README.md`, `values.yaml` and `NOTES.txt` between v0.7.0 and v0.16.0 against Install, Configuration and Upgrading; re-check the home page and the overview for claims that changed; update the checked facts in CLAUDE.md.