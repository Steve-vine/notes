---
id: 01KX6DMKFCYDB4VHZMFMPKRRZ3
created: 2026-07-10T16:26:43.052600935Z
updated: 2026-07-10T17:47:44.167495609Z
type: task
title: CI pipelines — PR gate, staging, main, image builds, secret scanning
task_status: todo
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 7
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
- 01KX6DKAQMQGJ47VAZYJRXHPD2
sprint: sh9ng2k
comments:
- id: 01KX6J8YN7Y3YB9Z1B7FJCWRCQ
  author: Steve Vine
  at: 2026-07-10T17:47:44.167374537Z
  text: 'CI infrastructure provisioned ahead of this task: ARC runner scale set `ise-runners` deployed to the g5 cluster (namespace arc-runners, gha-runner-scale-set chart 0.14.2, dind container mode, 0–4 runners, auth via shared gh-pat secret, scoped to github.com/Steve-vine/ise). Listener verified connected to GitHub''s scale-set broker. Workflows must use `runs-on: ise-runners`. Reference pattern: Compass ci.yml + docs/ci.md — self-hosted runners, zot.citops.net registry with pull-through mirror, immutable tags, in-cluster deploy RBAC. Documented in CLAUDE.md (CI summary).'
---
GitHub Actions per ADR 0011: PR→main full test suite (unit, lint, types, migration check); push→staging combined tests + staging deploy; push→main belt-and-braces + production build. Immutable `<branch>-yyyymmdd-hhmm` image tags (ADR 0008) and secret scanning.