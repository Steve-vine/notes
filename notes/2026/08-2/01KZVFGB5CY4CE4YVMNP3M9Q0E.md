---
id: 01KZVFGB5CY4CE4YVMNP3M9Q0E
created: 2026-08-12T17:14:47.340958Z
updated: 2026-08-12T17:15:34.182502Z
type: task
title: 'EC2 cutover 067: Playwright smoke harness on EC2/k3s'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 325
sprint: ssxh43d
assignee: steve
imported_from: linear
priority: medium
task_status: done
---
Fourth brief in the EC2 cutover. Adds the automated smoke harness referenced in `docs/workflow.md` and `docs/pr-review.md` as the last outstanding dependency for full async batched mode.

**Scope**

* **Framework:** Playwright (TypeScript), headless by default, headed via flag for local debugging.
* **Location:** `app/frontend/e2e/`.
* **Critical-path tests** (one spec each, total wall-clock target 3–5 minutes):
  * Login (smoke user)
  * Projec…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-285](https://linear.app/stevevine/issue/DEV-285/ec2-cutover-067-playwright-smoke-harness-on-ec2k3s)