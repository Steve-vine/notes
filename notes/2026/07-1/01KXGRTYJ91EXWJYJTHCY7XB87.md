---
id: 01KXGRTYJ91EXWJYJTHCY7XB87
created: 2026-07-14T16:54:49.673725525Z
updated: 2026-07-14T16:54:55.197937945Z
type: task
title: 'Deploy pipeline: roll GHCR images on k3s + auto-seed control library'
label:
- chore
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 24
sprint: sz3kacg
---
Surfaced during <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>. Make merges testable through the UI: point the k3s release at the GHCR images CI already builds (so a roll no longer needs a root node build), and auto-seed the control library on deploy.

Today: release.yml pushes immutable GHCR images on every merge, but the live k3s release still runs node-built local images (values-k3s.yaml pins tag local), which require a root nerdctl build on the node. The chart already runs Alembic via a pre-upgrade Job.

Prerequisite (Steve, one-time): create the ghcr-pull imagePullSecret in the compass namespace from a token with read:packages (command in chart/README.md). Claude cannot create this.

Work (chart):

* values-k3s.yaml → GHCR repos for backend + frontend, imagePullSecrets ghcr-pull, per-deploy tag override; update header comment.
* New templates/job-import.yaml — a post-install/post-upgrade hook Job that waits for Postgres then runs the import-controls CLI (idempotent; safe every deploy). Gated by importControls.enabled.
* _helpers.tpl — compass.import.fullname / labels (mirror migrate).
* values.yaml — importControls defaults block.
* NOTES.txt + README.md — document GHCR pull on k3s + the import hook.

Verify: helm lint / helm template render; then roll against the live cluster (after the secret exists) and confirm pods move to GHCR tags, the import Job logs 35/269, and the UI browses Domains/Controls.

Out of scope: the worker/beat Celery crash-loop (<issue id="7f7d24b6-5a6f-4707-95aa-6ac2206631b3" href="https://linear.app/stevevine/issue/DEV-416/wire-celery-app-broker-workerbeat-readyz-broker-check">DEV-416</issue>). Parent: <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>.

---
*Migrated from Linear [DEV-420](https://linear.app/stevevine/issue/DEV-420/deploy-pipeline-roll-ghcr-images-on-k3s-auto-seed-control-library) · created 2026-06-14 · completed 2026-06-14*  
*Related to (Linear): DEV-416, DEV-399, DEV-398*