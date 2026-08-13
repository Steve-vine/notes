---
id: 01KZEPWMCT0YGPY8MG1Q9NZP6Z
created: 2026-08-07T18:13:42.426322Z
updated: 2026-08-13T19:00:22.254874Z
type: task
title: 'Report runs: PDF render, object storage, on-demand runs'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 616
sprint: sw5yz4n
blocked_by:
- 01KZEPWE659A7HYH9B869W15AX
comments:
- id: 01KZP0FMAM71N5BRWKYFPVDB0B
  author: Steve Vine
  at: 2026-08-10T14:16:03.155932Z
  text: |-
    Built and pushed as PR #578 (branch feature/ise-616-report-runs, stacked on ISE-615 which is now merged to main). No migration; api-types regenerated.

    Done = press Run now, download the PDF, in both orientations — proven end to end against real MinIO and real WeasyPrint.

    Decisions:
    - **Unconfigured storage is a state, not an exception.** Run now answers 503 ON THE BUTTON, naming the settings — not a pending row that fails in a worker and reaches the operator as a red row in a list they have to go and find. Half-configured counts as unconfigured so it fails at the first look, not the first run.
    - **The enqueue happens AFTER the commit.** Enqueuing inside the transaction is the classic race: a fast worker picks the message up, finds no row, reports `not_found` — a Run now that silently does nothing. A test captures what was enqueued.
    - **The worker reads the snapshot, never the report** (ADR 0095 §5) — a test edits the report to match nothing after dispatch and asserts the run still returns the frozen result under the frozen name.
    - **Download is an authenticated proxy, not a presigned URL** (MinIO has no ingress). `has_artifact` is SERVED rather than inferred from `succeeded`, so a run whose file retention removed offers no broken link. Filename is slugged — `Estate — Q3/Q4` otherwise puts a path separator into a Content-Disposition header.

    **Found the hard way: `delete_objects` fails against MinIO.** The batch delete negotiates its integrity header differently per S3 implementation — a modern boto3 sends a CRC32 checksum where MinIO demands `Content-MD5`, and the whole batch fails `MissingContentMD5`. Switched to one `delete_object` per key: the shape every implementation agrees on, and a report's prefix holds ~20 objects. The LISTING is still paginated (a page caps at 1000 keys; a single-page delete would silently orphan the rest).

    Infra: MinIO statefulset/service cloned from the valkey pair, enabled by default, with the app and the store reading the SAME Secret keys so a rotated credential cannot reach only one side. Dockerfile pango/cairo libraries go in the RUNTIME stage — a builder-only install yields an image that starts fine and fails on the first report. CI gained the same apt set plus a MinIO pre-pull through the zot mirror.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Make a report runnable: press Run now, download the PDF. `storage.py` (S3-compatible via boto3, config-driven settings, path-style for MinIO; key scheme `reports/{report_id}/{run_id}.pdf`), jinja2 + weasyprint deps + pango apt packages in the shared backend image (worker-only import), `render.py` (SandboxedEnvironment, autoescape), `run_report` one-off task (FOR UPDATE pending→running idempotency) + `purge_report_artifacts`, run-now / runs-list / artifact-proxy endpoints (StreamingResponse + Content-Disposition; viewer download, operator run). Helm: MinIO statefulset/service cloned from valkey pair, secrets + ISE_STORAGE_* env wiring, `minio.enabled=false` + endpoint = external S3. compose.yaml minio service + .env.example. UI: Runs section with status pills + download link, Run now action.

Done = Run now produces a downloadable PDF in both orientations. No migration; api-types regen. Tests use testcontainers MinIO (extra widens to `testcontainers[postgres,minio]`). Depends on the definitions task.