---
id: 01M2GNB916JHC90RHHZ318NWE7
created: 2026-09-14T19:12:19.494434Z
updated: 2026-09-14T19:12:19.494434Z
type: task
title: The install ends with a system someone can sign in to — a bootstrap administrator and a deployment size
label: feature
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 714
---
ADR 0073 §9. Today the first administrator is created by `kubectl exec` into a running pod and running `python -m compass_api.cli create-admin` from a runbook — the point where an otherwise clean install stops being self-service.

**Bootstrap administrator.** `bootstrap.admin.enabled` (off by default) with an email address and initial password read from the app Secret (`BOOTSTRAP_ADMIN_EMAIL` / `BOOTSTRAP_ADMIN_PASSWORD` — supplied via `secrets.existingSecret` or the inline values). A post-install Job runs `create-admin` once; it does nothing on upgrade (post-install hook only), and does nothing if the user already exists. The install notes print the URL and the email to sign in with.

**Deployment size.** `size: evaluation | production` — one value that sets the six resource blocks and four replica counts that §1's 2 GB / 4 GB figures promise. `evaluation` = single replicas, small requests; `production` = today's defaults. Any explicit per-component value still wins, so nothing existing changes.

**Acceptance**: a fresh `helm install` with the bootstrap admin on finishes with a URL and credentials that sign in; a second `helm upgrade` does not re-run the Job or touch the user; `--set size=evaluation` renders a release whose requests total under 2 GB / 1 vCPU and `production` under 4 GB / 2 vCPU.