---
id: 01KXK84XSTDW2MXA8959WPNFGX
created: 2026-07-15T16:00:54.074665186Z
updated: 2026-07-16T07:32:48.976403099Z
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
comments:
- id: 01KXMXFA6G327ZW2XAXZ1KKT7A
  author: Steve Vine
  at: 2026-07-16T07:32:48.976317897Z
  text: |-
    Build complete on feature/com-174-review-outcomes; PR #165 open against main, branch merged to staging.

    **What was done**
    - _apply_review_outcome: the one place outcomes move posture (satisfactory→compliant, findings→under_review, unsatisfactory→non_compliant + active→non_compliant state coupling); posture changes stamp updated_by and write a revision, no-change outcomes write nothing.
    - compliance_status removed from VendorUpdate — with the review path live, the ADR's one-helper rule is now enforced at the API surface (COM-169 had left it PATCHable precisely because no review path existed yet).
    - Frontend: Reviews tab (history table + Record review modal), next-review ReviewDatePill in header and tab, Review cadence NumberInput on the details card; record-review mutation invalidates vendor/list/reviews/revisions so posture pills refresh.
    - 8 new tests across backend (4) and frontend (4); suites 84 unit + 22 integration + 175 Vitest green.

    **Local verification**: ruff + format, mypy src, Semgrep p/default clean, tsc/ESLint/Prettier/build pass.

    **Decisions made on the fly**
    - The unspecified `findings` outcome maps to compliance_status=under_review (open findings being worked) — satisfactory/unsatisfactory were the only mappings the ADR named.
    - A repeat satisfactory review on an already-compliant vendor writes no revision (helper returns changed=False) — keeps history meaningful.
---
Phase 2 (ADR 0039 §4): recording a review moves the vendor's posture, and reviews surface on the detail page.

- [x] Single `_apply_review_outcome` helper: satisfactory → `compliance_status=compliant`; findings → `under_review`; unsatisfactory → `non_compliant` and, if vendor is `active`, `state→non_compliant`. Only this helper (and Phase-3 approval activation) may move `compliance_status` — enforced by removing it from `VendorUpdate` (PATCH ignores the field). A posture change writes a revision; a no-change outcome writes none.
- [x] Detail page: Record-review action (date, kind, outcome, findings) on a new Reviews tab with the history table (date, kind, outcome pill, reviewer + snapshotted title, findings); next-review pill (`ReviewDatePill`) in the header + Reviews tab; Review cadence (months) field on the details card.
- [x] Tests: posture transitions per outcome, active→non_compliant coupling (new-state untouched), posture change writes exactly one revision, compliance_status not PATCHable (backend); header pill, history render, POST body captured, read-only gating (frontend).

Branch `feature/com-174-review-outcomes`, PR #165. Ref: ADR 0039 §2, §4.