---
id: 01M26KZ3K106KB0HJSKK03TJCQ
created: 2026-09-10T21:35:47.809273Z
updated: 2026-09-10T21:38:05.873596Z
type: task
title: Container register — record, AST ids, form, list and detail with audit trail, status and dependencies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 665
sprint: skdc1az
blocked_by:
- 01M26KYPTR3FYM4FR2TKD0HP6P
assignee: steve
label:
- feature
priority: high
task_status: todo
---
The **Containers** tab of the new Inventory module (ADR 0072): the register of systems, applications and datastores.

**Backend**
* `containers` — standard composition (`UUIDPrimaryKey`, `Timestamp`, `Actor`, `SoftDelete`, `CompanyScoped`): `asset_ref` (`AST-NNN`, from a deployment-wide sequence, unique, immutable), `name`, `aliases` (list), `kind` (`system | application | datastore`), `description`, `owner_id` (FK users, SET NULL) + `container_additional_owners`, `hosting` (`self_hosted | cloud | saas | on_prem`) + `hosting_detail` (account/region/site), `criticality` (the shared rubric) + `rto_minutes` / `rpo_minutes` (optional), `status` (`in_build | live | deprecated | decommissioned`) + `status_changed_at`, `environment` (`production | staging | development`, default production), `access_methods` (multi: `sso | local_accounts | api_keys | other`), `support_status` (`in_support | extended_support | end_of_life | unknown`), `last_verified_at`, `review_interval_days` (nullable, falls back to the register default).
* `container_dependencies` — container → container, coarse; both directions shown.
* Audited (`_AUDITED_TABLES`), so the detail page's **Audit trail** panel is the ADR 0023 activity view filtered to this record.
* Owner validation per ADR 0047 §2: must resolve to a Compass user; warn when the person has not signed in yet. Saving an owner auto-grants the `asset_owner` portal role if they hold nothing broader.
* Guarded delete: a container with holders, mapped data, dependencies or links answers 409 → decommission instead.
* `/api/v1/containers` CRUD + status transition; reads on `inventory.view`, writes on `inventory.manage_register`.

**Frontend**
* Inventory in the Modules nav beneath Access Control; page header + tab bar per *Screen conventions*.
* List: ref, name, kind, owner, criticality pill, classification pill (derived — blank until the data register, COM-666, lands), status pill, environment, last verified; every column sorts; rows link to the detail.
* Detail: header with ref + name + pills; sections for the record, hosting, resilience (criticality/RTO/RPO), lifecycle (status with dates, support status), dependencies, and the audit trail. Add/Edit in a modal; Decommission with a confirm.
* Register page states its scope: production unless entries say otherwise.

**Acceptance**: create, edit, decommission a container with the audit trail showing each change; `AST-` numbers never repeat across companies; a Critical container prompts for RTO/RPO.