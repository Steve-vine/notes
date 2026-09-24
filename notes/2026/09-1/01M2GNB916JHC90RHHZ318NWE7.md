---
id: 01M2GNB916JHC90RHHZ318NWE7
created: 2026-09-14T19:12:19.494434Z
updated: 2026-09-24T20:29:38.620694Z
type: task
title: The install ends with a system someone can sign in to — a bootstrap administrator and a deployment size
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 714
sprint: stek6vx
blocked_by:
- 01M2GDN2PFGVM8FND05VJ3WNCM
comments:
- id: 01M2GV0F3N0TJT4V0DV8KA5ZNR
  author: Steve Vine
  at: 2026-09-14T20:51:16.724891Z
  text: |-
    Merged to main 2026-09-14 20:49 as ffb5fb0 (PR #722) — with a defect: the sizing helper used a `nil` literal that Helm 4.2.4 (runner image, staging deploy) rejects while Helm 3.21 locally accepted it; the `chart` job flagged it on the PR and the merge went ahead before the result was read. Fixed forward in COM-715 (PR #723).

    What landed: `bootstrap.admin.*` with a post-install-only Job (weight 30) running create-admin, "already exists" treated as done, password generated/preserved and printed by the notes; `size: evaluation | production` with presets in `sizes.*`, a helper filling only empty component values so overlays still win. Acceptance met on g5 (scratch namespace, trunk build): size=evaluation + bundled Postgres + bootstrap admin → six pods in 2 min, `POST /api/v1/auth/login` with the generated password → 200 as an active admin, wrong password → 401. Requests: evaluation 0.43 vCPU / 1.0 GiB, production 0.75 vCPU / 1.75 GiB.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
ADR 0073 §9. Today the first administrator is created by `kubectl exec` into a running pod and running `python -m compass_api.cli create-admin` from a runbook — the point where an otherwise clean install stops being self-service.

**Bootstrap administrator.** `bootstrap.admin.enabled` (off by default) with an email address and initial password read from the app Secret (`BOOTSTRAP_ADMIN_EMAIL` / `BOOTSTRAP_ADMIN_PASSWORD` — supplied via `secrets.existingSecret` or the inline values). A post-install Job runs `create-admin` once; it does nothing on upgrade (post-install hook only), and does nothing if the user already exists. The install notes print the URL and the email to sign in with.

**Deployment size.** `size: evaluation | production` — one value that sets the six resource blocks and four replica counts that §1's 2 GB / 4 GB figures promise. `evaluation` = single replicas, small requests; `production` = today's defaults. Any explicit per-component value still wins, so nothing existing changes.

**Acceptance**: a fresh `helm install` with the bootstrap admin on finishes with a URL and credentials that sign in; a second `helm upgrade` does not re-run the Job or touch the user; `--set size=evaluation` renders a release whose requests total under 2 GB / 1 vCPU and `production` under 4 GB / 2 vCPU.