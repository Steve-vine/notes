---
id: 01M0885ZWABQ8TF6MGZAJGSF20
created: 2026-08-17T16:16:55.690835Z
updated: 2026-08-17T16:16:55.690835Z
type: task
title: Role matrix — business roles mapped to Entra security groups
priority: medium
task_status: todo
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 238
---
The governance heart of the domain: a per-company catalogue of **business roles** (e.g. "Service Desk Analyst", "Finance Manager") and the Entra security groups each implies. JML resolves "what should this person have" through it; recert asks "does reality still match".

* **Model**: `business_roles` — `Base, UUIDPrimaryKeyMixin, TimestampMixin, ActorMixin, SoftDeleteMixin, CompanyScopedMixin` (the `Vendor` composition), fields `name` (audit `_LABEL_ATTRS` reads it), `description`, `status active|disabled`; `business_role_groups` mapping rows FK'ing `directory_groups` by Entra object id. Both join `_AUDITED_TABLES` in `db/audit.py` — matrix edits are exactly what an auditor asks about.
* **API**: `api/v1/business_roles.py` CRUD + guarded delete (409 "in use — disable instead", the ADR 0027/0028 pattern) — a role referenced by open JML requests or campaigns disables, never vanishes.
* **UI**: first screen of the new Access section — the matrix view (roles × groups), role detail with group picker fed from the mirror (search, shows group description + member count), disabled-group warnings when a mapped group vanishes from the mirror.
* **Owner** field (FK → Compass users) per role — ADR 0015 §5 expresses responsibility through ownership FKs, and recert wants a default reviewer per role/group later.

Refs: ADR 0045, 0015, 0023, 0027; `models/vendor.py` (composition model), migrations from 0060.