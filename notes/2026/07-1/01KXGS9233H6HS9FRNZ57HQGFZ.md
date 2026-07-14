---
id: 01KXGS9233H6HS9FRNZ57HQGFZ
created: 2026-07-14T17:02:32.035119352Z
updated: 2026-07-14T17:02:32.035119352Z
type: task
title: Evidence attachments on risks
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 41
---
Real files attached to risks (ADR 0013) — supporting evidence for scoring, treatment and acceptance decisions. Reuses the polymorphic `Attachment` (`owner_type=risk`, already in the enum) and the storage backend exactly as <issue id="443c82f1-b512-468f-be8a-8714927911b9" href="https://linear.app/stevevine/issue/DEV-436/evidence-attachments-real-files-on-assessments">DEV-436</issue> did for assessments.

- [ ] Risk file attachments: upload / list / streamed download / delete (admin/editor), with the same content-type allowlist + size cap and forced-attachment download as <issue id="443c82f1-b512-468f-be8a-8714927911b9" href="https://linear.app/stevevine/issue/DEV-436/evidence-attachments-real-files-on-assessments">DEV-436</issue>.
- [ ] Risk detail UI: upload/list/remove evidence files (mirror the assessment panel's Evidence files section).

Refs: ADR 0013, 0012. Depends on: Risk register model + API. Relates to: Evidence attachments on assessments (<issue id="443c82f1-b512-468f-be8a-8714927911b9" href="https://linear.app/stevevine/issue/DEV-436/evidence-attachments-real-files-on-assessments">DEV-436</issue>).

---
*Migrated from Linear [DEV-453](https://linear.app/stevevine/issue/DEV-453/evidence-attachments-on-risks) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-436, DEV-452, DEV-451*