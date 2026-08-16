---
id: 01M04RRQXHBSPYRHHVNCWMDQCQ
created: 2026-08-16T07:49:49.617835Z
updated: 2026-08-16T09:41:02.483561Z
type: task
title: 'Vendor criticality: floor at highest engagement (incl. proposed) + admin raise-only override'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 218
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Design revision to COM-208's rollup, from smoke-testing (2026-08-16): a requested vendor showed no criticality because the rollup counted **active** engagements only, so the requester's engagement criticality (still `proposed`) never surfaced. New rules:

1. **Rollup counts all non-`ended` engagements** (proposed + active) — the vendor reflects the requester's criticality from the moment of request. Ended engagements still drop out (a terminated high engagement must not pin the vendor high forever).
2. **Vendor criticality = max(engagement max, admin override)** — the engagement max is a hard floor; an admin can set it **higher, never lower**.

- [ ] New `vendors.criticality_override` column (nullable, admin-set). Needed because a single stored column can't distinguish "admin raised it" from "an engagement pushed it up" — so when a high engagement ends, the recompute wouldn't know whether to drop back. Effective `vendor.criticality` = max(override, non-ended engagement max), recomputed by the existing rollup helper on engagement create/activate/amend/end **and on request submission** (proposed now counts).
- [ ] API: admin-only endpoint/field to set/clear the override; server rejects (422) an override below the current engagement max; clearing drops back to the engagement max. The COM-208 "leave unchanged when no engagement carries criticality" fallback is superseded: effective = max(override, engagement max), null when neither exists.
- [ ] Migration: for vendors whose stored criticality exceeds their engagement max (incl. engagement-less vendors), move the stored value into `criticality_override` — nothing lowers on upgrade. Append-only.
- [ ] Frontend (vendor detail): the derived criticality pill gains an admin-only "raise" control — options limited to values ≥ engagement max (client mirror; server enforces); hint shows the floor and why ("derives from the highest engagement; admins may set higher").
- [ ] Tests: proposed engagement raises vendor on submission; ending the high engagement drops back (respecting override); override below floor rejected; migration backfill.

Stacks on COM-208.