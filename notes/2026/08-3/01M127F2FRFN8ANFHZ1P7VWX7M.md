---
id: 01M127F2FRFN8ANFHZ1P7VWX7M
created: 2026-08-27T18:24:39.928101Z
updated: 2026-08-28T21:23:22.459472Z
type: task
title: How far in a vendor can reach is a rung on a ladder, not a sentence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 470
sprint: sd9gmcq
blocked_by:
- 01M127EWZ226VXDEESHY7799T9
comments:
- id: 01M15430PVJDV0DE4ZFH0BJRER
  author: Steve Vine
  at: 2026-08-28T21:23:22.459318Z
  text: |-
    Done — PR #485, merged to main 2026-08-28.

    What landed:

    - `vendor_access_levels` + `vendor_access_level_revisions`, the `vendor_criticality_levels` shape exactly: organisation-wide, fixed rank 0–3, fixed names, editable definitions, every edit preserved as a revision.
    - The ladder seeded verbatim from the ADR table — none / hosted / connected / privileged, "No access" through "Acts as us".
    - `ACCESS_RANK` derived from `ACCESS_SCALE` rather than written out a second time, so the severity order COM-472's thresholds compare against cannot disagree with the ladder it came from.
    - `GET/PATCH /api/v1/vendor-access-levels` (+ `/{rank}/revisions`). Reads on `require_portal_read`, not `require_vendor_read` — the person choosing a rung on a request form is often a portal employee with no vendor role at all, which was the COM-208 bug and is not repeated here. Prefixed `vendor-access-levels` because the access-control module (ADR 0045) owns the unqualified word.
    - Admin → Rubrics gains an *Access rubric* card beside Criticality and Data. That tab is now five cards, which is what one-card-per-rubric on one tab was for.
    - Migration 0136. Nothing added to `vendor_engagements` here — that was COM-471, deliberately, so existing engagements start with no rung rather than one guessed from the free text.

    Tests: `tests/test_access_rubric.py` (7) covers the seeded ladder, the fixed scale (405 on create/delete), names not editable, revisions, the read audience, `ACCESS_RANK` derivation, the served ladder matching the model, and the migration's seed. Frontend `AccessRubricSection.test.tsx` (3).
assignee: steve
company: null
label:
- feature
priority: medium
task_status: active
---
ADR 0060 §1. New `vendor_access_levels` — the `vendor_criticality_levels` shape exactly: `rank` 0–3 unique, `value` (enum, `StatusPill`), `name`, `definition`; organisation-wide, not company-scoped; fixed scale and fixed names, definition editable; every edit preserved as `vendor_access_level_revisions`.

Seed: 0 `none` "No access" · 1 `hosted` "Holds our data" · 2 `connected` "Reaches our systems" · 3 `privileged` "Acts as us". Definitions verbatim from the ADR table.

Also: `ACCESS_RANK` as the single source of severity order (the pattern `CRITICALITY_RANK` sets), the admin read/edit API, and an **Access rubric** section in Admin → Settings beside `CriticalityRubricSection` / `DataRubricSection`.

Migration note: reuse the enum with `postgresql.ENUM(create_type=False)` where it is referenced a second time.