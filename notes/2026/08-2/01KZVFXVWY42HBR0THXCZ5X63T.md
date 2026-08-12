---
id: 01KZVFXVWY42HBR0THXCZ5X63T
created: 2026-08-12T17:22:10.462757Z
updated: 2026-08-12T17:22:14.99164Z
type: task
title: 'CI: skip test.yml and build.yml on docs-only changes'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 360
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
## Problem

`.github/workflows/test.yml` and `.github/workflows/build.yml` both trigger on every push and PR with no path filter. A docs-only change (brief PRs, ADR PRs, CLAUDE.md edits, README updates) runs the full test matrix — backend lint/typecheck/test/coverage/integration, frontend lint/typecheck/test/build, Helm lint, Helm template + kubeconform, migrations portability — and on merge to main triggers `build.yml` as well. None of that exe…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-236](https://linear.app/stevevine/issue/DEV-236/ci-skip-testyml-and-buildyml-on-docs-only-changes)