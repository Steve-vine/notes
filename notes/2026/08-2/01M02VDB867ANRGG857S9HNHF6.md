---
id: 01M02VDB867ANRGG857S9HNHF6
created: 2026-08-15T13:57:33.062441Z
updated: 2026-08-15T13:57:33.062441Z
type: task
title: Backend — criticality rubric, engagement-level criticality, rule re-point + vendor rollup
priority: medium
assignee: steve
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 208
---
Business Criticality becomes a governed rubric and moves to the engagement; the vendor derives it. Mirrors the Data Rubric (ADR 0042) — no new ADR, a one-line note in 0042's consequences at most. Motivation: portal requests carry no criticality today (so `min_criticality` rules can never match them), and a vendor onboarded low could later add a high-criticality engagement that dodges both the rule and the vendor's label.

- [ ] **Criticality rubric**: `vendor_criticality_levels` table mirroring `data_sensitivity_levels` — fixed 4-row scale (rank 0–3 = Low/Medium/High/Critical), names fixed (enum values render in StatusPills), **definitions editable**, seeded defaults, edits preserved in `vendor_criticality_level_revisions` (a criticality that decided an approval stays interpretable after rewording).
- [ ] API: `GET /criticality-levels` readable by portal users (same access route as the data-type pick-list); admin-only `PUT` for definitions.
- [ ] **Engagement carries criticality**: `VendorEngagement.criticality` column; accepted on new_vendor / new_engagement request payloads (required on the portal form, enforced frontend); amendable — `proposed_criticality` on `vendor_onboarding_requests`, added to `_PROPOSABLE`, `ProjectedEngagement` and `apply_amendment` so raising criticality is judged by the rules.
- [ ] **`min_criticality` re-pointed** at the (projected) engagement instead of `vendor.criticality` — exact structural mirror of `min_sensitivity` in `core/vendor_approval.py`. Unset still matches nothing (ADR 0042 §4: the honest fix for missing data is to require the field).
- [ ] **Vendor rollup**: `vendor.criticality` stays a stored column (filters/dashboard/reports/pills read it) maintained by a single helper — max criticality across **active** engagements, recomputed on engagement activate / amend-apply / end. Proposed engagements never raise it. If no active engagement carries a criticality, the stored value is left unchanged (decided 2026-08-15: avoids nulling internally-created or dormant vendors).
- [ ] Migration: add columns + rubric tables, **backfill each vendor's current criticality onto its active engagements** so today's values survive and the rollup reproduces them. Append-only; `postgresql.ENUM(create_type=False)` when reusing `vendor_criticality`.
- [ ] Vendor criticality no longer writable via the vendor API (read-only derived); schema updated, OpenAPI regenerated.
- [ ] Tests: rubric CRUD + revisions, rule matching on projected criticality (incl. amendment escalation), rollup on activate/amend/end, migration backfill, portal read access.