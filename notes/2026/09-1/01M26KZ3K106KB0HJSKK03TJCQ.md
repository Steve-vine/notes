---
id: 01M26KZ3K106KB0HJSKK03TJCQ
created: 2026-09-10T21:35:47.809273Z
updated: 2026-09-11T19:27:52.556457Z
type: task
title: Container register — record, AST ids, form, list and detail with audit trail, status and dependencies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 665
sprint: skdc1az
blocked_by:
- 01M26KYPTR3FYM4FR2TKD0HP6P
comments:
- id: 01M26Q11RTSK6EFJMYQFW0Q59S
  author: Steve Vine
  at: 2026-09-10T22:29:17.210578Z
  text: |-
    Done — PR #673 merged to main.

    Backend: `containers`, `container_additional_owners`, `container_dependencies` (migration 0178, which also seeds the five inventory.* permissions for Admin); `/api/v1/containers` CRUD with the AST- sequence (deployment-wide), validated + dated lifecycle transitions, name unique per company, owner = active Compass user, full-set co-owners and dependencies, guarded delete (409 → decommission). Criticality reuses the one rubric via the `Criticality` alias (ADR 0072 §5). `core/inventory_reads.py` is the shared serialiser the portal router will reuse. Audit trail carries the ref in the create summary (number allocated before the flush). 11 integration tests.

    Frontend: Inventory in Modules beneath Access Control (gated on inventory.view), register at /inventory (filters, every column sorts, rows link, scope line), detail at /inventory/containers/:id (record, hosting, resilience, lifecycle with only the legal transitions and confirmed Decommission/Delete, dependencies both ways, and a reusable admin-only AuditTrailCard = ADR 0023 view filtered to the record), add/edit modal with the Critical → RTO/RPO prompt. schema.d.ts regenerated.

    Deferred on purpose: the asset_owner auto-grant and directory provisioning of owners go with COM-671, where the portal surface the role reaches exists; the classification pill and Data tab come with COM-666.
assignee: steve
label:
- feature
priority: high
task_status: done
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