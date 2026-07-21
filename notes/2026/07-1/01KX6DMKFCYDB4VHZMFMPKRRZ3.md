---
id: 01KX6DMKFCYDB4VHZMFMPKRRZ3
created: 2026-07-10T16:26:43.052600935Z
updated: 2026-07-21T17:37:27.139198Z
type: task
title: CI pipelines — PR gate, staging, main, image builds, secret scanning
project: 01KX671DATY39VW6GWK3M2T3DN
number: 7
sprint: sh9ng2k
blocked_by:
- 01KX6DK8PX9SQRVRFX2JAF86N8
- 01KX6DKAQMQGJ47VAZYJRXHPD2
comments:
- id: 01KX6J8YN7Y3YB9Z1B7FJCWRCQ
  author: Steve Vine
  at: 2026-07-10T17:47:44.167374537Z
  text: 'CI infrastructure provisioned ahead of this task: ARC runner scale set `ise-runners` deployed to the g5 cluster (namespace arc-runners, gha-runner-scale-set chart 0.14.2, dind container mode, 0–4 runners, auth via shared gh-pat secret, scoped to github.com/Steve-vine/ise). Listener verified connected to GitHub''s scale-set broker. Workflows must use `runs-on: ise-runners`. Reference pattern: Compass ci.yml + docs/ci.md — self-hosted runners, zot.citops.net registry with pull-through mirror, immutable tags, in-cluster deploy RBAC. Documented in CLAUDE.md (CI summary).'
- id: 01KX6K8V69MFWNY9PQSHPPC3K7
  author: Steve Vine
  at: 2026-07-10T18:05:09.192760011Z
  text: 'Development complete on feature/ise-007-ci-pipelines. PR #5: https://github.com/Steve-vine/ise/pull/5. Verified end-to-end on real infrastructure: PR run green on ise-runners (backend, frontend, secret-scan; build-images correctly skipped on PR); staging merge triggered the full pipeline — green, images pushed to zot as ise/{backend,frontend}:staging-20260710-1802 + :f393d12 (no latest). New Dockerfiles verified locally (backend non-root uvicorn, frontend unprivileged nginx). Branch protection enabled on main requiring backend/frontend/secret-scan. Deferred: Alembic migration check → ISE-4; Helm staging deploy + smoke → ISE-8. Awaiting merge clearance.'
- id: 01KX6M68ZTANXFSPANYB6Q7AC4
  author: Steve Vine
  at: 2026-07-10T18:21:13.594451443Z
  text: 'PR #5 merged to main (c18409a), branch deleted. Added before merge: path filtering via a changes job (dorny/paths-filter) so non-app changes (docs, CLAUDE.md) skip backend/frontend; secret-scan always runs. One live failure caught and fixed during rollout: paths-filter needs pull-requests:read (failed with "Resource not accessible by integration"); changes is now itself a required check so a filter failure blocks merges rather than skipping required tests. Verified: PR run green, staging run green, main run green with images ise/{backend,frontend}:main-20260710-1820 + :c18409a in zot. Minor follow-up someday: dorny/paths-filter pins Node 20 (deprecation warning). Done.'
assignee: steve
label: null
priority: high
task_status: done
---
GitHub Actions per ADR 0011: PR→main full test suite (unit, lint, types, migration check); push→staging combined tests + staging deploy; push→main belt-and-braces + production build. Immutable `<branch>-yyyymmdd-hhmm` image tags (ADR 0008) and secret scanning.