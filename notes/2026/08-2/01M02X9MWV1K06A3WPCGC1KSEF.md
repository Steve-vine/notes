---
id: 01M02X9MWV1K06A3WPCGC1KSEF
created: 2026-08-15T14:30:29.019266Z
updated: 2026-08-15T14:30:29.019266Z
type: task
title: Backend — Data Entities vocabulary + engagement link (parts of the business in scope)
assignee: steve
task_status: todo
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 210
---
New governed vocabulary for the engagement forms (decided 2026-08-15): **Data Entities** = the parts of the business whose data is in scope for an engagement — e.g. Moneypenny-UK, Moneypenny-US, Acquisition-1 — units with different (jurisdictional/regulatory) requirements. Mirrors the Data Types half of ADR 0042; not wired into approval rules (entities describe; sensitivity/criticality decide — a rule kind can be added later if e.g. "engagements touching X need Y approval").

- [ ] `data_entities` table mirroring `data_types` minus the sensitivity link: `name` (unique), `description`, `status` active/disabled, org-wide (no company scope), ActorMixin/TimestampMixin.
- [ ] CRUD API mirroring `/data-types`: list readable by portal users (same access route as the data-type pick-list), admin-gated create/update/disable; guarded against delete-in-use the same way data types are.
- [ ] Engagement ↔ entities M2M (`vendor_engagement_data_entities`), exposed on engagement read schemas (internal + portal).
- [ ] Request payloads: `data_entity_ids` on `VendorOnboardingEngagementIn` (new_vendor / new_engagement) landing as the relation, mirroring `data_type_ids` resolution in `_engagement_fields`.
- [ ] Amendable: `proposed_data_entities` JSONB ids on `vendor_onboarding_requests` + explicit handling in `projected_engagement` / `apply_amendment`, exactly as `proposed_data_types` (snapshot of ids, not a relation).
- [ ] Migration: table + M2M + request column, append-only.
- [ ] OpenAPI regenerated; tests: vocabulary CRUD + disable, request submission with entities, amendment overlay, portal read access.