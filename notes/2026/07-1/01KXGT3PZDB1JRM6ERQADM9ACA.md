---
id: 01KXGT3PZDB1JRM6ERQADM9ACA
created: 2026-07-14T17:17:05.389979221Z
updated: 2026-07-14T17:17:10.920432074Z
type: task
title: Export service — coverage report + gap/risk registers (CSV + PDF)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 70
sprint: s98e9vg
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Backend reporting/export engine (M15) so Compass produces audit-ready artifacts for all seven frameworks.

- [ ] **Draft an ADR** for reporting/export: PDF generation approach/library (e.g. a server-side HTML→PDF or a reportlab-style builder), sync vs async (Celery) generation for large reports/evidence packs, templating, and where generated artifacts live (ties to local/S3 storage backend, <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue>).
- [ ] **Per-framework coverage report** generator (reuse the existing coverage derivation): requirement-by-requirement status (met/partial/unmet/not_assessed/unmapped) for a given company + framework, with the contributing Core controls. CSV + PDF.
- [ ] **Gap register** and **risk register** exports (CSV + PDF) for a company.
- [ ] Endpoints: `GET /api/v1/reports/coverage?company=&framework=&format=`, `/reports/gaps`, `/reports/risks`; RBAC for reads; large/slow reports generated async with a job/poll or streamed.
- [ ] Tests (integration): coverage report numbers match the `/coverage` API; CSV + PDF render; registers export; RBAC enforced; company scoping correct.

New subsystem (beyond ADR 0014). Note: ISO SoA export stays as-is (it's ISO-specific); this is the generic, all-framework reporting layer.

---
*Migrated from Linear [DEV-499](https://linear.app/stevevine/issue/DEV-499/export-service-coverage-report-gaprisk-registers-csv-pdf) · created 2026-06-19 · completed 2026-06-19*  
*Related to (Linear): DEV-423*