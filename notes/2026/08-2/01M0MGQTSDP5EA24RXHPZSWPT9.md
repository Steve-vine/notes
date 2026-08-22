---
id: 01M0MGQTSDP5EA24RXHPZSWPT9
created: 2026-08-22T10:37:22.093541Z
updated: 2026-08-22T12:43:53.437036Z
type: task
title: Vendor detail Assessments tab — applicable assessments, Assign button, completed history
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 355
sprint: sbph5q5
blocked_by:
- 01M0MFZ5YKBJZ84F0MV1FX8CJC
assignee: steve
label:
- feature
priority: medium
task_status: active
---
On the admin vendor detail page (`VendorDetailPage.tsx`), add an **Assessments** tab. The ask said "between Details and Findings" — the current tabs are Details / Reviews / History with findings living inside Reviews, so it goes **between Details and Reviews**; if a separate Findings tab was intended that's its own conversation.

## What the tab shows

Everything that *applies* to this vendor, in two groups:

- [ ] **Uncompleted, at the top.** Two kinds in one group: assessments the Assessment Rules (COM-354's evaluation) say this vendor requires but which have **not been assigned** — each with an **Assign** button that creates the open (`pending`) `VendorAssessment` (the existing `POST /vendors/{id}/assessments` with that form) — and assessments already open on the vendor (assigned, awaiting completion, no button).
- [ ] **Completed, below**, with `completed_at` shown; each opens to the read-only record (the snapshotted prompts + answers via the existing detail endpoint).
- [ ] A form can appear in both groups (completed once, required again for a re-run) — the top group's "required but not assigned" check compares against *open* assessments, not against history, since re-runs are the designed path ("add the assessment again for a re-run", COM-190).

## Mechanics

- [ ] The existing `AssessmentsCard` currently renders inside the Details tab — it **moves** into the new tab (one home, not two); Details slims down accordingly.
- [ ] Backend: probably just one addition — a way to ask "which forms do the assessment rules require for this vendor?" (COM-354's evaluation exposed on the vendor read path, e.g. folded into the assessments list response with a `required`/`source` marker) — assign/complete/read all exist.
- [ ] Gating as today: reads on vendor read; Assign on vendor write (`canEdit`).
- [ ] Tests: grouping and ordering; Assign creates a pending assessment and the row moves groups; a rule-required form already open shows no button; completed rows show dates and open read-only; re-run case renders in both groups.