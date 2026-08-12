---
id: 01KZVBB8RPDYE5Q1ZNWK3FM5WP
created: 2026-08-12T16:02:06.742083Z
updated: 2026-08-12T16:04:25.330753Z
type: task
title: Scrub backend minikube references + retire stale e2e integration test
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 114
sprint: s1hm0kb
assignee: steve
imported_from: linear
label: null
priority: low
task_status: backlog
---
Follow-up from Brief 068 (DEV-286), which retired minikube but deliberately left backend code untouched (touching `config.py` mid-068 would have muddied that PR). No minikube *behaviour branch* exists anywhere — the K8s auth code is environment-agnostic. This is cleanup plus one real decision.

## Scope

**1. Cosmetic text (trivial):**

* `app/backend/src/redvektor_api/core/k8s.py` — module docstring line referencing "pointing at minikube".
* `app/backend/src/redvektor_api/core/config.py` — four `Field` descriptions mentioning "minikube-loaded image" (the `scanner_image_*` tag fields) and the kubeconfig field's "e.g. minikube" example.
* `app/backend/tests/test_dispatch_progress_polling.py` — DEV-161 historical comment (\~line 725). Cluster-agnostic test; comment only. Optional — arguably leave as historical context.

**2. Config contract (one line, do deliberately):**

* `config.py` line \~47: drop `"minikube"` from the `env` Literal (`prod|staging|dev|minikube|k3s|test`). Confirm nothing still sets `env: minikube` (the only setter was the now-deleted `values-minikube.yaml`). Technically a validation-contract change, hence not a blind sweep.

**3. Decision —** `app/backend/tests/integration/test_scan_e2e.py`**:**
Opt-in integration test (skipped by default via `RV_RUN_K8S_INTEGRATION=1`, not in CI), built around a live minikube + a `minikube image load`'d `redvektor/subfinder:local`. Setup is now stale. Brief 067's Playwright smoke harness covers the e2e-scan path against k3s.

* **Recommended: delete** as superseded by the smoke harness.
* Alternative: repoint at the k3s/dev cluster (`nerdctl`-built image, k3s namespace) if a Python-level e2e is still wanted alongside the browser smoke.

## Notes

* Small-fix sized: mostly text + one enum line + one delete/repoint decision. No new dependency, no schema change.
* Out of scope: anything touching the K8s auth/dispatch behaviour itself (none needed — it's already cluster-agnostic).

---

Imported from Linear [DEV-296](https://linear.app/stevevine/issue/DEV-296/scrub-backend-minikube-references-retire-stale-e2e-integration-test)