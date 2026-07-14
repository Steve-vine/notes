---
id: 01KXGT7YVW48YTGWRMEGXSYH8T
created: 2026-07-14T17:19:24.540668184Z
updated: 2026-07-14T17:19:31.682540735Z
type: task
title: Reports page + downloads + evidence pack
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 77
sprint: s98e9vg
---
Frontend for reporting/export (M15), consuming the report endpoints.

- [ ] Revamp the existing **Reports page**: pick company + report type (per-framework coverage / gap register / risk register) + framework selector, choose format (CSV / PDF), download. Handle async generation (job/poll or spinner) gracefully.
- [ ] **Evidence pack** action — assemble + download a bundle (coverage report + linked assessment evidence) for a company/framework.
- [ ] Surface report shortcuts where they belong (e.g. a "Download coverage report" button on the Framework detail / coverage view).
- [ ] Established patterns (TanStack Query, central toasts on success/failure, loading/empty states); Vitest coverage.

Depends on: Export service — coverage report + gap/risk registers (<issue id="0fa0fb62-53d6-4ee3-b327-b7c9f8ba0840" href="https://linear.app/stevevine/issue/DEV-499/export-service-coverage-report-gaprisk-registers-csv-pdf">DEV-499</issue>).

---
*Migrated from Linear [DEV-506](https://linear.app/stevevine/issue/DEV-506/reports-page-downloads-evidence-pack) · created 2026-06-19 · completed 2026-06-19*