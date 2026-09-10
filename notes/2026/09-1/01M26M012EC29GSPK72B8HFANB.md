---
id: 01M26M012EC29GSPK72B8HFANB
created: 2026-09-10T21:36:17.998434Z
updated: 2026-09-10T23:33:10.606814Z
type: task
title: CSV templates and create-only import for both registers, with row-level errors
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 668
sprint: skdc1az
blocked_by:
- 01M26KZ3K106KB0HJSKK03TJCQ
- 01M26KZF0BGCPFD74X2GSAVVS0
comments:
- id: 01M26TNYH5WJW7E3NY48FYG30E
  author: Steve Vine
  at: 2026-09-10T23:33:07.749794Z
  text: |-
    Done — PR #676 merged to main.

    Backend: `core/inventory_import.py` (templates with the header plus an example row listing allowed values; validate and commit for both registers — create-only, all-or-nothing, columns resolved by name: owner by Compass email or mirror UPN, criticality/data types/entities by name, containers by AST- ref, vendors by name, semicolon lists; every miss reported with row and column, all at once). Routes `GET /containers|data-assets/import/template.csv` and `POST …/import?company=&dry_run=`, mounted ahead of the register routers so the literal path wins. The dry run and the import run the same validation. Each created row's audit entry says `(source: csv_import)` via a session-level source stamp. 6 integration tests including the 51-row acceptance path and the data-asset resolution path.

    Frontend: Import CSV button on both tabs — template link, choose file, Check the file → row table with problems highlighted per row and column → Import (only after a clean check).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Bulk-populating the registers (ADR 0072): download a template, fill it in, upload it.

* **Template download** per register: `GET /api/v1/containers/import/template.csv` and `/data-assets/import/template.csv` — the header row plus one example row; enum columns list their allowed values in the example.
* **Import**: `POST …/import` (multipart, the frameworks enrichment pattern). **Create-only**: an existing name (case-insensitive, in the company) is a row error; **any row error rejects the whole file** — nothing is written unless every row passes. Response: created count, or the error list (row number, column, message).
* Columns resolve by name: owner by email/UPN against the mirror → Compass user; criticality and data types by name; data entities by name; containers on the data template by `AST-` ref, semicolon-separated; vendors by name.
* A **preview step** in the UI: upload → the server validates and returns the row table with errors highlighted → **Import** commits (a second call with the same file, or a validate-only flag on the first). No partial import, no upsert.
* Imported rows carry the importing user as actor; the audit trail shows one `create` per asset with `source: csv_import`.
* Gated on `inventory.manage_register`.

**Acceptance**: a valid 50-row file creates 50 containers; a file with one bad criticality creates nothing and names the row and column; re-uploading the same file reports every row as a duplicate name.