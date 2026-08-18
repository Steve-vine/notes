---
id: 01M0885ZWABQ8TF6MGZAJGSF20
created: 2026-08-17T16:16:55.690835Z
updated: 2026-08-18T12:50:53.394282Z
type: task
title: Role matrix — business roles mapped to Entra security groups
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 238
sprint: s5gwx0s
blocked_by:
- 01M0885S57BA00TPZNPQV9AXMF
comments:
- id: 01M08R87RN49PHZNZ9QWDN7PRC
  author: Steve Vine
  at: 2026-08-17T20:57:46.517311Z
  text: 'Done — merged to main (PR #239, squash 41ff961; migration 0063). business_roles (the Vendor mixin composition) + business_role_groups mapping rows FK''ing the mirror by Entra object id — mapping rows carry their own UUID so the audit listener records matrix edits row by row; both tables audited. The API validates only NEWLY ADDED mappings (present in the mirror, security kind, not role-assignable per §5, not vanished) so re-saving a role whose group has since vanished never fails — the vanished mapping stays and is flagged. /api/v1/directory/groups feeds the picker with member counts; role-assignable groups are returned flagged so the picker can say WHY they''re refused rather than being mysteriously absent. First Access screens shipped: the matrix list (group badges, vanished in red) and the role page (identity/owner/status editing, vanished-group alert, instant map/remove via full-set PATCH, explicit Refused badge). Delete is the guarded soft-delete — it gained real teeth in COM-239/241 (open requests and open campaigns refuse with 409). Integration tests cover all five mapping refusals with their messages, the vanished-resave case, and the authz matrix.'
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The governance heart of the domain: a per-company catalogue of **business roles** (e.g. "Service Desk Analyst", "Finance Manager") and the Entra security groups each implies. JML resolves "what should this person have" through it; recert asks "does reality still match".

* **Model**: `business_roles` — `Base, UUIDPrimaryKeyMixin, TimestampMixin, ActorMixin, SoftDeleteMixin, CompanyScopedMixin` (the `Vendor` composition), fields `name` (audit `_LABEL_ATTRS` reads it), `description`, `status active|disabled`; `business_role_groups` mapping rows FK'ing `directory_groups` by Entra object id. Both join `_AUDITED_TABLES` in `db/audit.py` — matrix edits are exactly what an auditor asks about.
* **API**: `api/v1/business_roles.py` CRUD + guarded delete (409 "in use — disable instead", the ADR 0027/0028 pattern) — a role referenced by open JML requests or campaigns disables, never vanishes.
* **UI**: first screen of the new Access section — the matrix view (roles × groups), role detail with group picker fed from the mirror (search, shows group description + member count), disabled-group warnings when a mapped group vanishes from the mirror.
* **Owner** field (FK → Compass users) per role — ADR 0015 §5 expresses responsibility through ownership FKs, and recert wants a default reviewer per role/group later.

Refs: ADR 0045, 0015, 0023, 0027; `models/vendor.py` (composition model), migrations from 0060.