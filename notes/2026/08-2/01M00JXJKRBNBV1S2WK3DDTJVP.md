---
id: 01M00JXJKRBNBV1S2WK3DDTJVP
created: 2026-08-14T16:50:38.840174Z
updated: 2026-08-14T16:50:57.907618Z
type: task
title: Backend — data rubric models, API and the min_sensitivity approval rule
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 206
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
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