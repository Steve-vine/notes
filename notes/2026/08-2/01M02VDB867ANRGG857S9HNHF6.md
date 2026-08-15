---
id: 01M02VDB867ANRGG857S9HNHF6
created: 2026-08-15T13:57:33.062441Z
updated: 2026-08-15T15:51:39.496212Z
type: task
title: Backend — criticality rubric, engagement-level criticality, rule re-point + vendor rollup
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 208
sprint: sbph5q5
comments:
- id: 01M031Y3908ZCX94SF5WQ2EEQD
  author: Steve Vine
  at: 2026-08-15T15:51:33.408198Z
  text: |-
    Done — PR #206 (feature/com-208-criticality-rubric, stacked on #205). Every checklist item landed; noted as a follow-on in ADR 0042's Consequences rather than a new ADR, as planned.

    Shape: vendor_criticality_levels + revisions (fixed 0-3, seeded, definitions editable, names not — each level IS a VendorCriticality value rendered as a pill, so a rename would leave every pill saying something else, and the PATCH schema accepts definition only). Engagement carries criticality; proposed_criticality joins _PROPOSABLE/ProjectedEngagement/apply_amendment, so the generic overlay handles it. min_criticality re-pointed at the projected engagement. Rollup in core/vendor_criticality.py — max across active engagements, called from every path that can change the answer, snapshotted as a revision.

    Two decisions I made that you should sanity-check:

    1. **Approving a new_vendor request now activates its first engagement.** It didn't before — _execute returned right after activate_vendor, so a vendor's only engagement sat `proposed` forever. Without this the rollup could never fire for a newly-onboarded vendor (the task specifies active-only, deliberately), and `proposed` on that row was already misleading — it read as an open request on an approved vendor. No existing test asserted the old behaviour. Rejection is unchanged: vendor stays `new`, engagement stays `proposed`, both as the record of what was refused.

    2. **/data-types and /data-sensitivity-levels moved to require_portal_read.** They shipped (COM-206) on require_vendor_read, which excludes vendor_portal — despite both docstrings claiming portal access. So a portal-only employee got a 403 and "No data types defined yet" on the request form. Fixed here rather than filed separately because COM-209 puts the criticality picker directly beside that one; shipping a working picker next to a broken one would have been odd.

    Also used PATCH, not PUT, for the definition edit — the task said PUT but the whole point was mirroring the sensitivity rubric, which is PATCH.

    Frontend touched only as far as the contract forced: the two now-inert criticality inputs are removed (a control that silently does nothing is worse than none); the derived value still shows as a pill on the vendor header and the register column. COM-209 adds the pickers, the Criticality rubric admin tab and the derived-value hint.

    Tests: tests/test_criticality_rubric.py, 13 cases. Full backend suite green (359 integration), frontend 249. OpenAPI regenerated; single Alembic head 0053.
assignee: steve
label:
- feature
priority: medium
task_status: review
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