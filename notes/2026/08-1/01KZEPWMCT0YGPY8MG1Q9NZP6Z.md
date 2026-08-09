---
id: 01KZEPWMCT0YGPY8MG1Q9NZP6Z
created: 2026-08-07T18:13:42.426322Z
updated: 2026-08-09T20:03:08.864097Z
type: task
title: 'Report runs: PDF render, object storage, on-demand runs'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 616
sprint: sw5yz4n
blocked_by:
- 01KZEPWE659A7HYH9B869W15AX
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Make a report runnable: press Run now, download the PDF. `storage.py` (S3-compatible via boto3, config-driven settings, path-style for MinIO; key scheme `reports/{report_id}/{run_id}.pdf`), jinja2 + weasyprint deps + pango apt packages in the shared backend image (worker-only import), `render.py` (SandboxedEnvironment, autoescape), `run_report` one-off task (FOR UPDATE pending→running idempotency) + `purge_report_artifacts`, run-now / runs-list / artifact-proxy endpoints (StreamingResponse + Content-Disposition; viewer download, operator run). Helm: MinIO statefulset/service cloned from valkey pair, secrets + ISE_STORAGE_* env wiring, `minio.enabled=false` + endpoint = external S3. compose.yaml minio service + .env.example. UI: Runs section with status pills + download link, Run now action.

Done = Run now produces a downloadable PDF in both orientations. No migration; api-types regen. Tests use testcontainers MinIO (extra widens to `testcontainers[postgres,minio]`). Depends on the definitions task.