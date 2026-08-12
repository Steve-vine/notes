---
id: 01KZVBCBAQABKR4QXSAE4FFMJJ
created: 2026-08-12T16:02:42.135587Z
updated: 2026-08-12T16:02:42.135587Z
type: task
title: Helm 3 → 4 upgrade decision (Helm 3 bug-fix EOL 2026-07-08)
imported_from: linear
priority: low
task_status: backlog
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 118
---
Brief 064 (DEV-282) pinned helm to v3.20.2 per brief's `3.x` specification. Helm 3 is now in support mode:

* Bug fixes until 2026-07-08 (\~6 weeks)
* Security fixes until 2026-11-11

Decide between:

1. Bump to Helm 4 across the bootstrap script and any chart instructions
2. Accept security-only support through 2026-11-11 and revisit then
3. Defer decision until forced (after security EOL)

Likely worth folding into Brief 066's chart work since `values-k3s.yaml` is being added then — could validate against Helm 4 at the same time, or stay on Helm 3 deliberately and document.

Surfaced by Code in the session summary for Brief 064 implementation.

---

Imported from Linear [DEV-287](https://linear.app/stevevine/issue/DEV-287/helm-3-4-upgrade-decision-helm-3-bug-fix-eol-2026-07-08)