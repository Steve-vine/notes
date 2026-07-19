---
id: 01KXGS3FEZPHHBG9V6YY5F2YYS
created: 2026-07-14T16:59:29.119014908Z
updated: 2026-07-19T10:21:55.200085Z
type: task
title: ISO 27001 Statement of Applicability export
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 34
sprint: s9wnr7r
blocked_by:
- 01KXGS0FW4BN20F9TNN2C9V2AS
comments:
- id: 01KXGS3T6KBENDC582ZE80W9P2
  author: Steve Vine
  at: 2026-07-14T16:59:40.115186115Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 09:10 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/31

    **Delivered** (all three checklist items)
    - **SoA export API** `GET /api/v1/soa?company=&framework=&format=csv|xlsx` — one row per Annex A control with applicability + justification, derived implementation status, and the mapped Core control(s). Reuses the DEV-434 coverage derivation (single-sourced), extended with `applicability_justification`. Applicable = No only when every mapped control is explicitly excluded (ISO applicable-by-default). Added `openpyxl` for the XLSX.
    - **Reports page** (was a placeholder): framework + format pickers + a Download SoA button that anchors straight to the API (cookie-authenticated), company-scoped with an empty state.

    User chose **CSV + XLSX** for the format scope.

    **Verification**: backend ruff/mypy + 4 SoA tests (CSV/XLSX content, headers/filename, applicability/justification, 404/auth); frontend lint/typecheck/33 tests (2 new)/format/build — all green. Ships on the next image roll.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Per-company ISO 27001 Statement of Applicability export (ADR 0011 — exportable directly from assessment data).

- [ ] SoA generation: each ISO 27001 Annex A control (via the crosswalk) with applicability + justification, implementation status, and the mapped Core control(s) — per company.
- [ ] Export endpoint + download (CSV/XLSX; PDF optional) under the Reports section.
- [ ] UI: generate/download the SoA for the current company.

Depends on: Framework models + import (+ Crosswalk, M2 Assessments). Refs: ADR 0011, 0017.

---
*Migrated from Linear [DEV-435](https://linear.app/stevevine/issue/DEV-435/iso-27001-statement-of-applicability-export) · created 2026-06-16 · completed 2026-06-17*  
*Related to (Linear): DEV-434*