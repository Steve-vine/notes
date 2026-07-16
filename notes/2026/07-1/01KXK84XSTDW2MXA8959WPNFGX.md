---
id: 01KXK84XSTDW2MXA8959WPNFGX
created: 2026-07-15T16:00:54.074665186Z
updated: 2026-07-16T07:32:33.285699096Z
type: task
title: Review outcomes drive vendor posture + review history UI
task_status: review
priority: medium
assignee: steve
label:
- brief
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 174
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
sprint: sxady3y
---
Phase 2 (ADR 0039 §4): recording a review moves the vendor's posture, and reviews surface on the detail page.

- [x] Single `_apply_review_outcome` helper: satisfactory → `compliance_status=compliant`; findings → `under_review`; unsatisfactory → `non_compliant` and, if vendor is `active`, `state→non_compliant`. Only this helper (and Phase-3 approval activation) may move `compliance_status` — enforced by removing it from `VendorUpdate` (PATCH ignores the field). A posture change writes a revision; a no-change outcome writes none.
- [x] Detail page: Record-review action (date, kind, outcome, findings) on a new Reviews tab with the history table (date, kind, outcome pill, reviewer + snapshotted title, findings); next-review pill (`ReviewDatePill`) in the header + Reviews tab; Review cadence (months) field on the details card.
- [x] Tests: posture transitions per outcome, active→non_compliant coupling (new-state untouched), posture change writes exactly one revision, compliance_status not PATCHable (backend); header pill, history render, POST body captured, read-only gating (frontend).

Branch `feature/com-174-review-outcomes`, PR #165. Ref: ADR 0039 §2, §4.