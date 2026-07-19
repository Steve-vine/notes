---
id: 01KXK879GYKT6A8WGY1MTX66C6
created: 2026-07-15T16:02:11.614637933Z
updated: 2026-07-19T21:30:27.100484707Z
type: task
title: Vendor reporting + dashboard tile
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 187
sprint: sjkp918
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
comments:
- id: 01KXP77CM9JESVECNXHE2AMQEP
  author: Steve Vine
  at: 2026-07-16T19:42:29.513222481Z
  text: |-
    Built on feature/com-187-reporting (stacked on com-186) — PR #178, merged to staging (8c020a9). No migration.

    - GET /api/v1/reports/vendors (CSV/PDF, ADR 0024 pipeline) reusing the vendors router's flag + derived-next-review helpers so report and register never diverge; gated require_vendor_read.
    - GET /api/v1/vendors/summary → dashboard posture tile: counts by state/criticality + overdue-review count (reminders-scan semantics: dormant/offboarded excluded); badges link into the register with filters applied — VendorsPage now reads state/status/criticality from URL params.
    - Reports page vendor-register download card, gated on vendor read.

    Gates: 88 unit + 294 integration, 195 Vitest, mypy strict, ruff, build, Semgrep — all green.
assignee: steve
task_status: done
priority: medium
---
Phase 4 (ADR 0039 §7): vendor register export and posture-at-a-glance.

- [x] `/api/v1/reports/vendors` — vendor register CSV + PDF (state, compliance status, criticality, owner, flags, last/next review), reusing the ADR 0024 ReportLab pipeline; Reports page download card.
- [x] Dashboard tile: counts by state/criticality + overdue-review count, linking into the register with filters applied.
- [x] Tests: report renders, tile counts.

Ref: ADR 0039 §7, ADR 0024.