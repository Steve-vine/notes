---
id: 01KXK85SRYTH1CMBR0RDZW7GTF
created: 2026-07-15T16:01:22.718039423Z
updated: 2026-07-16T18:50:34.098081338Z
type: task
title: VendorEngagement entity
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 178
sprint: sxngp10
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
comments:
- id: 01KXNF79RHY6VR7ZJ3RHXP5TJ8
  author: Steve Vine
  at: 2026-07-16T12:43:00.752976325Z
  text: |-
    Build complete on feature/com-178-vendor-engagements; PR #169 open against main, branch merged to staging. Batch mode: PRs held open for the Sprint 28 release; branches stack (shared migration chain) — merge #169 first.

    Decisions: no DELETE endpoint — status=ended retires an engagement since Phase-3 approvals evaluate per engagement and history must stay interpretable; data_types is the vendor domain's first JSONB list (assessment_revision.evidence_links precedent) with TagsInput free labels in the UI.

    Local verification: ruff + format, mypy src, 84 unit + 6 integration, 182 Vitest, build, Semgrep clean.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Phase 3 (ADR 0039 §5): the per-engagement record that approval criteria are evaluated against.

- [x] `models/vendor_engagement.py` (UUID/Timestamp/Actor/CompanyScoped): `vendor_id` FK RESTRICT, `scope`, `data_types` (JSONB list), `data_residency`, `access_requirements`, `sub_processors`, status proposed/active/ended + migration 0041.
- [x] Sub-resource API under `/vendors/{id}/engagements` [read/write gates]: GET/POST/PATCH; no DELETE — `status=ended` retires (approval history stays interpretable).
- [x] Engagements card on the vendor detail page (scope + status pill + data-type badges + residency; add/edit modal with TagsInput).
- [x] Tests: 3 backend integration (JSONB round trip + ended retirement, scoping 404s, role gating) + 2 frontend Vitest.

Branch `feature/com-178-vendor-engagements`, PR #169 (Sprint 28 stacks: merge first at release). Ref: ADR 0039 §5.