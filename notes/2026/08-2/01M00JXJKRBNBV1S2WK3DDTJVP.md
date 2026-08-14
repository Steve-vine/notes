---
id: 01M00JXJKRBNBV1S2WK3DDTJVP
created: 2026-08-14T16:50:38.840174Z
updated: 2026-08-14T18:38:40.448261Z
type: task
title: Backend — data rubric models, API and the min_sensitivity approval rule
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 206
sprint: sbph5q5
blocked_by:
- 01M00JX0RFGYJA4H0GD5KC1J4B
comments:
- id: 01M00S3C67CGG7JXKYFFRHDXNX
  author: Steve Vine
  at: 2026-08-14T18:38:40.327235Z
  text: |-
    Shipped. PR #201 squash-merged to main as 709b89e. Migration head is now 0052_data_rubric.

    Built as specified, with two decisions worth recording:

    Sensitivity is stored on approval rules as a rank int (min_sensitivity_rank) rather than an FK to the level row. The scale is fixed and rows are never deleted, so the rank is a stable natural key — the same reasoning that has the maturity API address levels by their level number.

    The frontend consumers moved with the backend, in this PR rather than COM-207. This was a breaking contract change: with the API renamed to data_type_ids and returning resolved rows, the six vendor screens no longer compiled, so leaving them would have made the PR red — and a PR is the only gate. COM-207 narrowed to the new Admin > Data Rubric tab as a result. The six sites now use a shared DataTypePicker (each option showing its sensitivity, since that is what decides the approvals) and the rule editor offers a sensitivity threshold. A legacy data_types_any row renders as "Retired rule (no longer applied)" rather than reading as a live control.

    Two things found while building:
    - The constraint naming convention generates a 68-character identifier for data_sensitivity_level_revisions -> data_sensitivity_levels, over Postgres's 63-char limit. That FK and the engagement join table's FK are explicitly named, in the models as well as the migration so the two cannot drift.
    - An engagement's data types are now a relation while a request's proposal is JSONB ids, so data_types had to come out of the generic _PROPOSABLE overlay in core/vendor_approval.py and be handled explicitly. It is the most rule-relevant field of the five, so the comment there warns against dropping the special case.

    Verification: backend 94 unit + 346 integration green, mypy strict clean, ruff clean; frontend 239 green, tsc + eslint clean; single Alembic head, no OpenAPI drift.

    CI note: backend-test failed once on infrastructure, not code — zot could not serve testcontainers/ryuk:0.8.1 (502s then DNS timeouts). Manifest fetches were measured intermittent (timeout / 200 in 6.3s / timeout). Passed on re-run.

    Not yet deployed — staging release goes out once all four sprint tasks are in Review. Before that deploy: check migration 0052's log output, which lists every free-text data type and data_types_any rule it destroys.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Backend half of the Data Rubric (ADR 0042). Turns `VendorEngagement.data_types` from free labels into a governed vocabulary and re-points the approval criteria at sensitivity.

**Models**
* `data_sensitivity_levels` — the fixed ordered scale, modelled on `models/maturity_level.py`: `rank` (0–3, unique), `name`, `definition`, plus `data_sensitivity_level_revisions` so wording edits never change the meaning of a sensitivity already recorded (ADR 0018). Seeded by the migration with Public / Internal / Confidential / Restricted; rows are editable but not addable or deletable — the scale is fixed, like maturity 0–5.
* `data_types` — `name` (unique), `definition`, FK to a sensitivity level, `active|disabled` status. **Ships empty.** Reversible disable plus a guarded delete (409 "in use — disable instead") following the ADR 0028 pattern, because historical engagements point at these rows.
* `vendor_engagements.data_types` — free-text JSONB gives way to a reference to `data_types` (join table vs JSONB id list settled in ADR 0042). `vendor_onboarding_requests.proposed_data_types` carries ids alongside the other `proposed_*` columns.

**Approval rules** (`models/approval_rule.py`, `core/vendor_approval.py`)
* New kind `min_sensitivity` with a threshold column, mirroring `min_criticality` exactly — including its null handling.
* `rule_matches` computes the engagement's **effective sensitivity** = the highest rank across its data types, and fires at or above the threshold. An engagement with no data types does not match.
* `data_types_any` and its `data_types` column are retired. The enum value stays (Postgres cannot drop one; migrations are append-only) but is no longer offered or matched.

**Migration** — the risky part, so do it deliberately:
* Check the live data *before* writing it: existing engagement `data_types` values and any `data_types_any` rules are **cleared**, per the ADR 0042 decision. Log every distinct value and every deleted rule in the migration output so an admin can re-create them; nothing should vanish silently.
* Reusing the existing `approval_rule_kind` enum across migrations needs `postgresql.ENUM(create_type=False)` — `sa.Enum` passes fresh-DB CI and then fails the incremental deploy.

**API** — `/api/v1/data-sensitivity-levels` (list + edit + revision history) and `/api/v1/data-types` (CRUD + disable), both admin-gated for writes, readable by anyone who can read vendors so the pick-lists work. Existing vendor and portal schemas carrying `data_types` update in step (`api/v1/schemas.py`, `vendor_onboarding.py`, `approval_areas.py`, `portal.py`).

**Tests:** effective-sensitivity matching at, above and below the threshold; no-data-types engagement; the disable/guarded-delete path; the migration against a database holding legacy free-text values and a `data_types_any` rule.

Blocked by COM-205 (the ADR settles the join-table and enum-retirement questions). Frontend follows in COM-207.

Refs: ADR 0042, 0039 §5–6, 0028, 0018, 0026, 0005.