---
id: 01KXK84XSTDW2MXA8959WPNFGX
created: 2026-07-15T16:00:54.074665186Z
updated: 2026-07-15T16:00:54.074665186Z
type: task
title: Review outcomes drive vendor posture + review history UI
task_status: backlog
priority: medium
assignee: steve
label: brief
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 174
---
Phase 2 (ADR 0039 §4): recording a review moves the vendor's posture, and reviews surface on the detail page.

- [ ] Single `_apply_review`-style helper: satisfactory → `compliance_status=compliant`; unsatisfactory → `non_compliant` and, if vendor is `active`, `state→non_compliant`. Only this helper (and Phase-3 approval activation) may move `compliance_status`.
- [ ] Detail page: Record-review action (date, kind, outcome, findings), review history tab, next-review pill (`ReviewDatePill`).
- [ ] Tests: posture transitions per outcome, active→non_compliant coupling.

Ref: ADR 0039 §2, §4.