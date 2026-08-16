---
id: 01M04RRQXHBSPYRHHVNCWMDQCQ
created: 2026-08-16T07:49:49.617835Z
updated: 2026-08-16T11:30:29.761052Z
type: task
title: 'Vendor criticality: floor at highest engagement (incl. proposed) + admin raise-only override'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 218
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
comments:
- id: 01M055CSA3EQ064T78K48FQY5V
  author: Steve Vine
  at: 2026-08-16T11:30:29.315115Z
  text: |-
    Done — PR #216, merged to main.

    Both rules implemented as specified.

    **Proposed engagements now count.** The rollup reads every non-ended engagement, so a requested vendor carries the criticality its requester stated from the moment of submission — including on the auto-approve and rejected paths. Nothing pretends it is approved: the vendor still reads `new` and the engagement `proposed`. Two existing COM-208 tests changed meaning as a result and were rewritten rather than patched around (a rejected new-vendor request now keeps its criticality, and retiring the only engagement now drops the vendor back).

    **`vendors.criticality_override`**, exactly for the reason in the brief — one column could not tell an admin's decision from a rolled-up one, so the recompute had no way to know whether it was allowed to drop back. Effective = max(override, floor); null only when neither exists. Admin-only (403 for a manager) and raise-only (422 below the floor, naming the floor in the message). Snapshotted on `vendor_revisions` too, since it is a governance fact about the vendor.

    `VendorOut` publishes `criticality_override` and `criticality_floor` alongside the effective value. The floor is computed from the live engagements already in the response, so explaining the number costs no extra query — on the detail page or a 200-row register.

    Migration 0056 backfills both directions and only ever upward: a stored value above the floor becomes an override; a vendor under a proposed engagement rises to it.

    Frontend: the derived pill gains an admin-only raise picker offering only values ≥ the floor (the rule is visible rather than discovered through a 422), a "Raised by an admin" badge, and a hint naming the floor.

    **One CI note:** semgrep blocked the first push — the migration composed its SQL from f-strings over module constants. Nothing untrusted was interpolated, but that is the shape the rule exists to catch, so the two statements are now written out in full.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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