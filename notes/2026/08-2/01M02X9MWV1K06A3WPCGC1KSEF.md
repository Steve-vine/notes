---
id: 01M02X9MWV1K06A3WPCGC1KSEF
created: 2026-08-15T14:30:29.019266Z
updated: 2026-08-25T18:42:59.686183Z
type: task
title: Backend — Data Entities vocabulary + engagement link (parts of the business in scope)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 210
sprint: sbph5q5
comments:
- id: 01M032NNNTYTTPMSC735RD8743
  author: Steve Vine
  at: 2026-08-15T16:04:25.914321Z
  text: |-
    Done — PR #207 (feature/com-210-data-entities, stacked on #206). Every checklist item landed as specified.

    data_entities mirrors data_types minus the sensitivity link: org-wide, unique names (case-insensitive), description, active/disabled, ships empty. CRUD at /api/v1/data-entities — admin-only writes, list on require_portal_read (the same gate COM-208 corrected for data-types), guarded delete with the same "disable it instead" 409, disabled entities legible where recorded but not newly selectable.

    Engagement M2M exposed on both surfaces; data_entity_ids on the request payload; proposed_data_entities as JSONB ids with the same null-means-unchanged / empty-means-none distinction as proposed_data_types (there's a test for the null case specifically — it's the one that would silently clear a set if the plumbing were sloppy).

    I did carry data_entities on ProjectedEngagement even though no rule reads them, per the task. Left a comment saying why: it keeps the projection an honest picture of the outcome, and makes a future data_entities_any rule a change to rule_matches alone.

    Kept data_entities.py as a near-copy of data_types.py rather than factoring a generic "governed vocabulary" — the two are one field apart today and the data types' sensitivity is a routing input while entities are purely descriptive, so the shared abstraction would be over a similarity that isn't structural. Noted in the module docstring.

    Tests: tests/test_data_entities.py, 9 cases. Full backend suite green (368 integration), frontend 249. OpenAPI regenerated; single Alembic head 0054.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
New governed vocabulary for the engagement forms (decided 2026-08-15): **Data Entities** = the parts of the business whose data is in scope for an engagement — e.g. Moneypenny-UK, Moneypenny-US, Acquisition-1 — units with different (jurisdictional/regulatory) requirements. Mirrors the Data Types half of ADR 0042; not wired into approval rules (entities describe; sensitivity/criticality decide — a rule kind can be added later if e.g. "engagements touching X need Y approval").

- [ ] `data_entities` table mirroring `data_types` minus the sensitivity link: `name` (unique), `description`, `status` active/disabled, org-wide (no company scope), ActorMixin/TimestampMixin.
- [ ] CRUD API mirroring `/data-types`: list readable by portal users (same access route as the data-type pick-list), admin-gated create/update/disable; guarded against delete-in-use the same way data types are.
- [ ] Engagement ↔ entities M2M (`vendor_engagement_data_entities`), exposed on engagement read schemas (internal + portal).
- [ ] Request payloads: `data_entity_ids` on `VendorOnboardingEngagementIn` (new_vendor / new_engagement) landing as the relation, mirroring `data_type_ids` resolution in `_engagement_fields`.
- [ ] Amendable: `proposed_data_entities` JSONB ids on `vendor_onboarding_requests` + explicit handling in `projected_engagement` / `apply_amendment`, exactly as `proposed_data_types` (snapshot of ids, not a relation).
- [ ] Migration: table + M2M + request column, append-only.
- [ ] OpenAPI regenerated; tests: vocabulary CRUD + disable, request submission with entities, amendment overlay, portal read access.