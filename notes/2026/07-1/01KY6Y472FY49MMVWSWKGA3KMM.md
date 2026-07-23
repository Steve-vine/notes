---
id: 01KY6Y472FY49MMVWSWKGA3KMM
created: 2026-07-23T07:30:33.679117Z
updated: 2026-07-23T09:08:57.044305Z
type: task
title: 'CI: bump GitHub Actions off deprecated Node 20'
assignee: steve
label: follow_up
number: 10
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Surfaced during DEV-478. CI runs green but logs a deprecation warning:

> Node.js 20 is deprecated. The following actions target Node.js 20 but are being forced to run on Node.js 24: actions/checkout@v4, actions/setup-node@v4, actions/upload-artifact@v4.

Ref: [https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/](<https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/>)

**Checklist**

- [X] Bump pinned action versions in `.github/workflows/ci.yml` to releases that target Node 24 (checkout v7, setup-node v6, upload-artifact v7)
- [X] Confirm CI is green with no Node deprecation warning (verified: 0 occurrences in run logs)

**Note:** also bumped the build runtime `node-version` 20→22 (current LTS). `Swatinem/rust-cache@v2` left as-is (current, not flagged); `dtolnay/rust-toolchain` is composite (no Node).

**Done when:** CI runs without the Node 20 deprecation warning.

**PR:** [https://github.com/Steve-vine/notula/pull/6](<https://github.com/Steve-vine/notula/pull/6>)

---

Linear DEV-489 · M1 — Foundation · created 2026-06-19 · done 2026-06-19