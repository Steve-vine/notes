---
id: 01KZKCY1SV4CR8KEY7TZ8R989D
created: 2026-08-09T13:55:55.323311Z
updated: 2026-08-09T13:56:33.615626Z
type: task
title: 'Vendor request kinds: new engagement + amendment'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 193
sprint: sw3i5is
blocked_by:
- 01KZKCX3891CBRC8S0V33HC1DS
assignee: steve
priority: medium
task_status: todo
---
Generalise the onboarding request into a **vendor request** carrying a `kind`, so "request a new engagement" and "request an amendment to an existing engagement" run through the same multi-area approval workflow as "request a new vendor". ADR 0040.

---

## Agreed work (planned with Claude, 2026-08-09)

**Scoping decisions (Steve):**
- One request entity with `kind`, not three tables — the approval-areas / rules / per-area-decisions machinery is reused wholesale.
- **Table keeps its name** (`vendor_onboarding_requests`): renaming churns the FKs from `vendor_approvals` / `vendor_form_answers` and the stored `NotificationTargetType.vendor_onboarding_request` values for no gain. The `kind` column is the truth.
- Amendment payload is **typed nullable `proposed_*` columns**, not a JSONB blob — the ADR 0039 §7 reasoning (mypy-strict models, honest generated TS types).
- `engagement_id` stays NOT NULL: every kind has an engagement (created for the first two, targeted for the third).

**Checklist:**
- [ ] `models/vendor_onboarding_request.py` — `VendorRequestKind` (`new_vendor | new_engagement | amend_engagement`); columns `kind` (`server_default='new_vendor'` for backfill), `justification` (all kinds), and nullable `proposed_scope` / `proposed_data_types` (JSONB) / `proposed_data_residency` / `proposed_access_requirements` / `proposed_sub_processors` (populated only for `amend_engagement`). Migration **0051**.
- [ ] `core/vendor_requests.py` — extract the submit / approval-fan-out / status-derivation logic currently inline in `api/v1/vendor_onboarding.py:193-260` into one shared service, so `vendor_onboarding.py` and `portal.py` submit identically (the single-helper discipline ADR 0039 already applies to `_apply_review_outcome` / `_activate_vendor`).
- [ ] `core/vendor_approval.py` — pure `projected_engagement(engagement, request)` returning the effective post-amendment values; `required_area_ids` evaluates against the projection, so an amendment that *adds* a rule-triggering data type pulls in the same areas a new engagement would.
- [ ] `_apply_derived_status` branches on kind: `new_vendor` → `_activate_vendor` (unchanged); `new_engagement` → engagement `proposed → active`; `amend_engagement` → apply non-null `proposed_*` onto the engagement; **rejected + `new_engagement` → engagement `proposed → ended`** (the model's stated retirement record — there is no delete).
- [ ] `POST /portal/requests` accepts all three kinds via the shared service. Guards: 409 if an open request already targets that engagement; 422 on amending an `ended` engagement; 404 cross-company.
- [ ] Notifications unchanged in shape — approval-pending to area approvers, decision to the requester; titles/bodies reworded per kind.
- [ ] Tests: all three kinds submitted → correct required areas (incl. an amendment that adds a triggering data type) → approved applies the right effect; rejected ends a proposed engagement; guards fire; migration upgrade **and downgrade** cycle green.
- [ ] PR to main, merge branch to staging.
