---
id: 01KXK879GYKT6A8WGY1MTX66C6
created: 2026-07-15T16:02:11.614637933Z
updated: 2026-07-16T19:42:25.675136542Z
type: task
title: Vendor reporting + dashboard tile
assignee: steve
label:
- brief
priority: medium
task_status: review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 187
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
sprint: sjkp918
---
Phase 4 (ADR 0039 §7): vendor register export and posture-at-a-glance.

- [x] `/api/v1/reports/vendors` — vendor register CSV + PDF (state, compliance status, criticality, owner, flags, last/next review), reusing the ADR 0024 ReportLab pipeline; Reports page download card.
- [x] Dashboard tile: counts by state/criticality + overdue-review count, linking into the register with filters applied.
- [x] Tests: report renders, tile counts.

Ref: ADR 0039 §7, ADR 0024.